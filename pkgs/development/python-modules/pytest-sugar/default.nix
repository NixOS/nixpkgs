{ lib
, buildPythonPackage
, fetchPypi
, termcolor
, pytest
, packaging
}:

buildPythonPackage rec {
  pname = "pytest-sugar";
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1630b5b7ea3624919b73fde37cffb87965c5087a4afab8a43074ff44e0d810c4";
  };

  propagatedBuildInputs = [
    termcolor
    pytest
    packaging
  ];

  meta = with lib; {
    description = "A plugin that changes the default look and feel of py.test";
    homepage = "https://github.com/Frozenball/pytest-sugar";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
