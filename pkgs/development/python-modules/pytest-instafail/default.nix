{ buildPythonPackage
, fetchPypi
, lib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-instafail";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-M6YG9+DI5kbcO/7g1eOkt7eO98NhaM+h89k698pwbJ4=";
  };

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "pytest_instafail" ];
  meta = {
    description = "pytest plugin that shows failures and errors instantly instead of waiting until the end of test session";
    homepage = "https://github.com/pytest-dev/pytest-instafail";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.jacg ];
  };
}
