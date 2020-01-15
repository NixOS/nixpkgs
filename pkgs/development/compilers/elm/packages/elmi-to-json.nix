{ mkDerivation, aeson, async, base, binary, bytestring, containers
, directory, filepath, hpack, optparse-applicative, safe-exceptions
, stdenv, text, fetchgit
}:
mkDerivation {
  pname = "elmi-to-json";
  version = "0.19.4";
  src = fetchgit {
    url = "https://github.com/stoeffel/elmi-to-json.git";
    rev = "357ad96f05e4c68023b036f27f6f65c4377c7427";
    sha256 = "0vj9fdqgg2zd1nxpll6v02fk6bcyhx00xhp3s8sd7ycvirwsim9n";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson async base binary bytestring containers directory filepath
    optparse-applicative safe-exceptions text
  ];
  libraryToolDepends = [ hpack ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [ base ];
  preConfigure = "hpack";
  homepage = "https://github.com/stoeffel/elmi-to-json#readme";
  description = "Translates elmi binary files to JSON representation";
  license = stdenv.lib.licenses.bsd3;
  maintainers = with stdenv.lib.maintainers; [ turbomack ];
}
