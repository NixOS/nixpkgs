{ mkDerivation, aeson, base, binary, bytestring, containers
, directory, fetchgit, filepath, ghc-prim, hpack
, optparse-applicative, stdenv, text, unliftio
, unordered-containers
}:
mkDerivation {
  pname = "elmi-to-json";
  version = "1.2.0";
  src = fetchgit {
    url = "https://github.com/stoeffel/elmi-to-json.git";
    sha256 = "1kxai87h2g0749yq0fkxwk3xaavydraaivhnavbwr62q2hw4wrj7";
    rev = "af08ceafe742a252f1f1f3c229b0ce3b3e00084d";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base binary bytestring containers directory filepath ghc-prim
    optparse-applicative text unliftio unordered-containers
  ];
  libraryToolDepends = [ hpack ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [ base ];
  prePatch = "hpack";
  homepage = "https://github.com/stoeffel/elmi-to-json#readme";
  license = stdenv.lib.licenses.bsd3;
}
