{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, setuptools-scm
, ansible-base
, enrich
, flaky
, pyyaml
, rich
, ruamel-yaml
, tenacity
, wcmatch
, yamllint
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ansible-lint";
  version = "5.3.2";
  disabled = isPy27;
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-m6iG20xE5ZNgvI1mjwvq5hk8Ch/LuedhJwAMo6ztfCg=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    ansible-base
    enrich
    flaky
    pyyaml
    rich
    ruamel-yaml
    tenacity
    wcmatch
    yamllint
  ];

  checkInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--numprocesses" "$NIX_BUILD_CORES"
  ];

  preCheck = ''
    # ansible wants to write to $HOME and crashes if it can't
    export HOME=$(mktemp -d)
    export PATH=$PATH:${lib.makeBinPath [ ansible-base ]}

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

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ ansible-base ]}" ];

  meta = with lib; {
    homepage = "https://github.com/ansible-community/ansible-lint";
    description = "Best practices checker for Ansible";
    license = licenses.mit;
    maintainers = with maintainers; [ sengaya SuperSandro2000 ];
  };
}
