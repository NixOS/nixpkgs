{ lib
, buildPythonPackage
, fetchPypi
, unittest2
, python
, isPy27
}:

buildPythonPackage rec {
  pname = "pyxl3";
  version = "1.3";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "23831c6d60b2ce3fbb39966f6fb21a5e053d6ce0bd08b00bb50fa388631b69ee";
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
