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
  version = "5.0.8";
  disabled = isPy27;
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tnuWKEB66bwVuwu3H3mHG99ZP+/msGhMDMRL5fyQgD8=";
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
    "--numprocesses" "auto"
  ];

  postPatch = ''
    # Both patches are addressed in https://github.com/ansible-community/ansible-lint/pull/1549
    # and should be removed once merged upstream

    # fixes test_get_yaml_files_umlaut and test_run_inside_role_dir
    substituteInPlace src/ansiblelint/file_utils.py \
      --replace 'os.path.join(root, name)' 'os.path.normpath(os.path.join(root, name))'
    # fixes test_custom_kinds
    substituteInPlace src/ansiblelint/file_utils.py \
      --replace "if name.endswith('.yaml') or name.endswith('.yml')" ""
  '';

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
    "test_prerun_reqs_v1"
    "test_prerun_reqs_v2"
  ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ ansible-base ]}" ];

  meta = with lib; {
    homepage = "https://github.com/ansible-community/ansible-lint";
    description = "Best practices checker for Ansible";
    license = licenses.mit;
    maintainers = with maintainers; [ sengaya SuperSandro2000 ];
  };
}
