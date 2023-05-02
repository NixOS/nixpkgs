{ lib
, buildPythonPackage
, fetchFromGitHub
, ansible-core
, coreutils
, coverage
, pytest
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-ansible";
  version = "3.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ansible";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-kxOp7ScpIIzEbM4VQa+3ByHzkPS8pzdYq82rggF9Fpk=";
  };

  postPatch = ''
    substituteInPlace tests/conftest.py inventory \
      --replace '/usr/bin/env' '${coreutils}/bin/env'
  '';

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    ansible-core
  ];

  nativeCheckInputs = [
    coverage
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pytestFlagsArray = [
    "tests/"
  ];

  disabledTests = [
    # Host unreachable in the inventory
    "test_become"
    # [Errno -3] Temporary failure in name resolution
    "test_connection_failure_v2"
    "test_connection_failure_extra_inventory_v2"
  ];

  pythonImportsCheck = [
    "pytest_ansible"
  ];

  meta = with lib; {
    description = "Plugin for py.test to simplify calling ansible modules from tests or fixtures";
    homepage = "https://github.com/jlaska/pytest-ansible";
    changelog = "https://github.com/ansible-community/pytest-ansible/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
