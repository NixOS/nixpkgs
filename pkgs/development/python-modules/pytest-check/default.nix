{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-check";
  version = "2.5.4";
  pyproject = true;

  src = fetchPypi {
    pname = "pytest_check";
    inherit version;
    hash = "sha256-M9h+KNXkkhf0Eyd+Hg0mfNZskKhaIIlExEMSycjk/3Q=";
  };

  build-system = [ hatchling ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_check" ];

  meta = with lib; {
    description = "Pytest plugin allowing multiple failures per test";
    homepage = "https://github.com/okken/pytest-check";
    changelog = "https://github.com/okken/pytest-check/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
