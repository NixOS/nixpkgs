{ lib
, fetchPypi
, buildPythonPackage
, py
, pytestCheckHook
, pytest-html
 }:

buildPythonPackage rec {
  pname = "cucumber-tag-expressions";
  version = "6.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-N1jTEjFe+sghWGXbF4N0jfXvZjJDUgaLMvhFt3B/7Vs=";
  };

  nativeCheckInputs = [
    py
    pytestCheckHook
    pytest-html
  ];

  meta = with lib; {
    homepage = "https://github.com/cucumber/tag-expressions";
    description = "Provides tag-expression parser for cucumber/behave";
    license = licenses.mit;
    maintainers = with maintainers; [ maxxk ];
  };
}
