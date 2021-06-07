{ lib, fetchPypi, buildPythonPackage, nose }:

buildPythonPackage rec {
  version = "1.16";
  pname = "python-stdnum";
  src = fetchPypi {
    inherit pname version;
    sha256 = "4248d898042a801fc4eff96fbfe4bf63a43324854efe3b5534718c1c195c6f43";
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
