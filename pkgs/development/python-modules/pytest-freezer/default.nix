{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, freezegun
, pytest
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-freezer";
  version = "0.4.8";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Eak6LNoyu2wvZbPaBBUO0UkyB9vni8YbsADGK0as7Cg=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    freezegun
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_freezer"
  ];

  meta = with lib; {
    description = "Pytest plugin providing a fixture interface for spulec/freezegun";
    homepage = "https://github.com/pytest-dev/pytest-freezer";
    changelog = "https://github.com/pytest-dev/pytest-freezer/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
