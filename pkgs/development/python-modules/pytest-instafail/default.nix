{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pytest-instafail";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-M6YG9+DI5kbcO/7g1eOkt7eO98NhaM+h89k698pwbJ4=";
  };

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_instafail" ];

  meta = with lib; {
    description = "pytest plugin that shows failures and errors instantly instead of waiting until the end of test session";
    homepage = "https://github.com/pytest-dev/pytest-instafail";
    changelog = "https://github.com/pytest-dev/pytest-instafail/blob/v${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jacg ];
  };
}
