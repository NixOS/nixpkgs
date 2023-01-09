{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, ansible-compat
, ansible-core
, black
, enrich
, filelock
, flaky
, jsonschema
, pythonOlder
, pytest
, pytest-xdist
, pytestCheckHook
, pyyaml
, rich
, ruamel-yaml
, wcmatch
, yamllint
}:

buildPythonPackage rec {
  pname = "ansible-lint";
  version = "6.10.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4ihEmsLxDRwW3zXEdpKCtSmsH+K1B2czP60chaYt9nE=";
  };

  postPatch = ''
    # it is fine if lint tools are missing
    substituteInPlace conftest.py \
      --replace "sys.exit(1)" ""
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    ansible-compat
    ansible-core
    black
    enrich
    filelock
    jsonschema
    pytest # yes, this is an actual runtime dependency
    pyyaml
    rich
    ruamel-yaml
    wcmatch
    yamllint
  ];

  # tests can't be easily run without installing things from ansible-galaxy
  doCheck = false;

  checkInputs = [
    flaky
    pytest-xdist
    pytestCheckHook
  ];

  preCheck = ''
    # ansible wants to write to $HOME and crashes if it can't
    export HOME=$(mktemp -d)
    export PATH=$PATH:${lib.makeBinPath [ ansible-core ]}

    # create a working ansible-lint executable
    export PATH=$PATH:$PWD/src/ansiblelint
    ln -rs src/ansiblelint/__main__.py src/ansiblelint/ansible-lint
    patchShebangs src/ansiblelint/__main__.py

    # create symlink like in the git repo so test_included_tasks does not fail
    ln -s ../roles examples/playbooks/roles
  '';

  disabledTests = [
    # requires network
    "test_cli_auto_detect"
    "test_install_collection"
    "test_prerun_reqs_v1"
    "test_prerun_reqs_v2"
    "test_require_collection_wrong_version"
    # re-execs ansible-lint which does not works correct
    "test_custom_kinds"
    "test_run_inside_role_dir"
    "test_run_multiple_role_path_no_trailing_slash"
    "test_runner_exclude_globs"
    "test_discover_lintables_umlaut"
  ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ ansible-core ]}" ];

  meta = with lib; {
    description = "Best practices checker for Ansible";
    homepage = "https://github.com/ansible/ansible-lint";
    changelog = "https://github.com/ansible/ansible-lint/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sengaya ];
  };
}
