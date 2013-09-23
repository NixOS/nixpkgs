{ cabal, aeson, attoparsec, cmdargs, text, unorderedContainers
, vector
}:

cabal.mkDerivation (self: {
  pname = "aeson-pretty";
  version = "0.7";
  sha256 = "0zkqs3f4mr0v0j582h9ssq7dxgfkk59s7y66b640hc4zf0b5p7g7";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec cmdargs text unorderedContainers vector
  ];
  meta = {
    homepage = "http://github.com/informatikr/aeson-pretty";
    description = "JSON pretty-printing library and command-line tool";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
