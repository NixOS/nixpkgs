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
  version = "0.9.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xHk0lfPDLhFPD1QWKQlGwxbrlq1aNoTc2t2pJn5Zsrg=";
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
