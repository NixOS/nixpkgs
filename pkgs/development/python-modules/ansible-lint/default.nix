{ lib
, stdenv
, fetchPypi
, buildPythonPackage
, isPy27
, ansible
, pyyaml
, ruamel-yaml
, rich
, pytestCheckHook
, pytest-xdist
, git
, wcmatch
, enrich
, python
, tenacity
, flaky
, yamllint
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

  buildInputs = [ python ];

  propagatedBuildInputs = [ ansible enrich pyyaml rich ruamel-yaml wcmatch tenacity flaky yamllint ];

  checkInputs = [ pytestCheckHook pytest-xdist git ];

  preCheck = ''
    # ansible wants to write to $HOME and crashes if it can't
    export HOME=$(mktemp -d)
    export PATH=$PATH:${lib.makeBinPath [ ansible ]}

    # create a working ansible-lint executable
    export PATH=$PATH:$PWD/src/ansiblelint
    ln -rs src/ansiblelint/__main__.py src/ansiblelint/ansible-lint
    patchShebangs src/ansiblelint/__main__.py
  '';

  disabledTests = [
    # requires network
    "test_prerun_reqs_v1"
    "test_prerun_reqs_v2"
    # Assertion error with negative numbers; maybe requieres an ansible update?
    "test_included_tasks"

    "test_get_yaml_files_umlaut"
    "test_run_inside_role_dir"
    "test_custom_kinds"
    "test_rule_no_handler"
  ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ ansible ]}" ];

  meta = with lib; {
    homepage = "https://github.com/ansible-community/ansible-lint";
    description = "Best practices checker for Ansible";
    license = licenses.mit;
    maintainers = with maintainers; [ sengaya SuperSandro2000 ];
  };
}
