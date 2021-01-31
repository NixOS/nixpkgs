{ lib
, buildPythonPackage
, fetchPypi
, isPy27
}:

buildPythonPackage rec {
  pname = "cachetools";
  version = "4.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9Gninnqkz/ZNjeSq2VznbejqESWhbGjg2T9lw8Pckuk=";
  };

  meta = with lib; {
    description = "Extensible memoizing collections and decorators";
    homepage = "https://github.com/tkem/cachetools";
    license = licenses.mit;
  };
}
