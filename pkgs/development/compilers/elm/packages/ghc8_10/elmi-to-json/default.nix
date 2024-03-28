{ mkDerivation, aeson, base, binary, bytestring, containers
, directory, fetchgit, filepath, ghc-prim, hpack, lib
, optparse-applicative, text, unliftio, unordered-containers
}:
mkDerivation {
  pname = "elmi-to-json";
  version = "unstable-2021-07-19";
  src = fetchgit {
    url = "https://github.com/stoeffel/elmi-to-json";
    hash = "sha256-9fScXRSyTkqzeXwh/Jjza6mnENCThlU6KI366CLFcgY=";
    rev = "bd18efb59d247439b362272b480e67a16a4e424e";
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
  license = lib.licenses.bsd3;
  mainProgram = "elmi-to-json";
}
