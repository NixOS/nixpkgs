{ lib
, buildPythonPackage
, fetchPypi
, termcolor
, pytest
, packaging
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-sugar";
  version = "0.9.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8edMGr+lX3JBz3CIAytuN4Vm8WuTjz8IkF4s9ElO3UY=";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    termcolor
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A plugin that changes the default look and feel of py.test";
    homepage = "https://github.com/Frozenball/pytest-sugar";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
