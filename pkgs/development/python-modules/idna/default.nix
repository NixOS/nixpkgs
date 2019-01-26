{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "idna";
  version = "2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "684a38a6f903c1d71d6d5fac066b58d7768af4de2b832e426ec79c30daa94a16";
  };

  meta = {
    homepage = "https://github.com/kjd/idna/";
    description = "Internationalized Domain Names in Applications (IDNA)";
    license = lib.licenses.bsd3;
  };
}