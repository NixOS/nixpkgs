{ lib
, buildPythonPackage
, fetchPypi
, unittest2
, python
, isPy27
}:

buildPythonPackage rec {
  pname = "pyxl3";
  version = "1.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "df413d86664e2d261f67749beffff07eb830ab8c7bbe631d11d4c42f3a5e5fde";
  };

  checkInputs = [ unittest2 ];

  checkPhase = ''
     ${python.interpreter} tests/test_basic.py
  '';

  # tests require weird codec installation
  # which is not necessary for major use of package
  doCheck = false;

  meta = with lib; {
    description = "Python 3 port of pyxl for writing structured and reusable inline HTML";
    homepage = https://github.com/gvanrossum/pyxl3;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
