{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "0.4.0";
  pname = "BespON";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4acfa3f918d416654beccd4db69290f498edb78bf39941287dcbc068b9a7ce2f";
  };

  propagatedBuildInputs = [ ];
  # upstream doesn't contain tests
  doCheck = false;
  
  pythonImportsCheck = [ "bespon" ];
  meta = with stdenv.lib; {
    description = "Encodes and decodes data in the BespON format.";
    homepage = "https://github.com/gpoore/bespon_py";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ synthetica ];
  };

}
