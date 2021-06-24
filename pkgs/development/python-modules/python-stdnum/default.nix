{ lib, fetchPypi, buildPythonPackage, nose }:

buildPythonPackage rec {
  version = "1.14";
  pname = "python-stdnum";
  src = fetchPypi {
    inherit pname version;
    sha256 = "fd3a92b8ec82a159c41dbaa3c5397934d090090c92b04e346412e0fd7e6a1b1c";
  };

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests
  '';

  meta = {
    homepage = "https://arthurdejong.org/python-stdnum/";
    description = "Python module to handle standardized numbers and codes";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.lgpl2Plus;
  };
}
