{ lib
, buildPythonPackage
, fetchPypi
, unittest2
, python
, isPy27
}:

buildPythonPackage rec {
  pname = "pyxl3";
  version = "1.4";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ad4cc56bf4b35def33783e6d4783882702111fe8f9a781c63228e2114067c065";
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
    homepage = "https://github.com/gvanrossum/pyxl3";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
