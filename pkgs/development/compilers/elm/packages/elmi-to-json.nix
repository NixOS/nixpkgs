{ mkDerivation, aeson, base, binary, bytestring, containers
, directory, fetchgit, filepath, ghc-prim, hpack
, optparse-applicative, stdenv, text, unliftio
, unordered-containers
}:
mkDerivation {
  pname = "elmi-to-json";
  version = "1.3.0";
  src = fetchgit {
    url = "https://github.com/stoeffel/elmi-to-json";
    sha256 = "11j56vcyhijkwi9hzggkwwmxlhzhgm67ab2m7kxkhcbbqgpasa8n";
    rev = "ae40d1aa1e3d6878f2af514e611d44890e7abc1e";
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
