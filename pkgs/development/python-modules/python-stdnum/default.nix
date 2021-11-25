{ lib, fetchPypi, buildPythonPackage, nose }:

buildPythonPackage rec {
  version = "1.17";
  pname = "python-stdnum";
  src = fetchPypi {
    inherit pname version;
    sha256 = "374e2b5e13912ccdbf50b0b23fca2c3e0531174805c32d74e145f37756328340";
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
