{ lib
, buildPythonPackage
, fetchPypi
, termcolor
, pytest
, packaging
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-sugar";
  version = "0.9.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8edMGr+lX3JBz3CIAytuN4Vm8WuTjz8IkF4s9ElO3UY=";
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    termcolor
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A plugin that changes the default look and feel of pytest";
    homepage = "https://github.com/Frozenball/pytest-sugar";
    changelog = "https://github.com/Teemu/pytest-sugar/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
