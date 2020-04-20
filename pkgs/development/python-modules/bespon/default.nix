{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "0.3.0";
  pname = "BespON";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0698vx1kh8c84f5qfhl4grdlyn1lljvdih8yczdz0pql8wkn8i7v";
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
