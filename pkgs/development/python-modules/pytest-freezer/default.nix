{ lib
, buildPythonPackage
, fetchFromGitHub
, freezegun
, hatchling
, pytest
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-freezer";
  version = "0.4.6";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-0JZv6MavRceAV+ZOetCVxJEyttd5W3PCts6Fz2KQsh0=";
  };

  nativeBuildInputs = [
    hatchling
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
