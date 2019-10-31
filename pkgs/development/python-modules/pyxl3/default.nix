{ lib
, buildPythonPackage
, fetchPypi
, unittest2
, python
, isPy27
}:

buildPythonPackage rec {
  pname = "pyxl3";
  version = "1.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f1fc74d2ab59073ef6bf0ce01b4f2891366bbf89a8187de85433486b284df758";
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
