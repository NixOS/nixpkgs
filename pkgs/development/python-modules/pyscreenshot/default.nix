{ lib
, buildPythonPackage
, fetchPypi
, EasyProcess
}:

buildPythonPackage rec {
  pname = "pyscreenshot";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7322ad9454652b1702a3689646ce53ef01ed2b14869ea557030bd4e03a06fc0e";
  };

  propagatedBuildInputs = [
    EasyProcess
  ];

  # recursive dependency on pyvirtualdisplay
  doCheck = false;

  meta = with lib; {
    description = "python screenshot";
    homepage = "https://github.com/ponty/pyscreenshot";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
