{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "0.6.0";
  pname = "BespON";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2f2bda67fea8ee95c8aa7e885835ab88bdbfa392a94077ce1c9d29017420ce7a";
  };

  propagatedBuildInputs = [ ];
  # upstream doesn't contain tests
  doCheck = false;

  pythonImportsCheck = [ "bespon" ];
  meta = with lib; {
    description = "Encodes and decodes data in the BespON format.";
    homepage = "https://github.com/gpoore/bespon_py";
    license = licenses.bsd3;
    maintainers = with maintainers; [ synthetica ];
  };

}
