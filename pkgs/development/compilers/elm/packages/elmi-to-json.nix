{ mkDerivation, aeson, base, binary, bytestring, containers
, directory, fetchgit, filepath, ghc-prim, hpack
, optparse-applicative, lib, text, unliftio
, unordered-containers
}:
mkDerivation {
  pname = "elmi-to-json";
  version = "1.3.0";
  src = fetchgit {
    url = "https://github.com/stoeffel/elmi-to-json";
    rev = "bd18efb59d247439b362272b480e67a16a4e424e";
    sha256 = "sha256-9fScXRSyTkqzeXwh/Jjza6mnENCThlU6KI366CLFcgY=";
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
}
