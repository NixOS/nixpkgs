{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "0.5.0";
  pname = "BespON";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a75cd7e62746fb0fef9b98aa157a44f9ed2ef63e952f7ae4ec5b3c2892669187";
  };

  propagatedBuildInputs = [ ];
  # upstream doesn't contain tests
  doCheck = false;

  pythonImportsCheck = [ "bespon" ];
  meta = with lib; {
    description = "Encodes and decodes data in the BespON format.";
    homepage = "https://github.com/gpoore/bespon_py";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ synthetica ];
  };

}
