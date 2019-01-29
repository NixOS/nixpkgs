{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "0.10.7";
  pname = "netifaces";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bd590fcb75421537d4149825e1e63cca225fd47dad861710c46bd1cb329d8cbd";
  };

  meta = with stdenv.lib; {
    homepage = https://alastairs-place.net/projects/netifaces/;
    description = "Portable access to network interfaces from Python";
    license = licenses.mit;
  };

}
