{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "0.11.0";
  pname = "netifaces";

  src = fetchPypi {
    inherit pname version;
    sha256 = "043a79146eb2907edf439899f262b3dfe41717d34124298ed281139a8b93ca32";
  };

  doCheck = false; # no tests implemented

  pythonImportsCheck = [ "netifaces" ];

  meta = with lib; {
    homepage = "https://alastairs-place.net/projects/netifaces/";
    description = "Portable access to network interfaces from Python";
    license = licenses.mit;
  };

}
