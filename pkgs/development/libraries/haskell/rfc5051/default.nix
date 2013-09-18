{ cabal }:

cabal.mkDerivation (self: {
  pname = "rfc5051";
  version = "0.1.0.2";
  sha256 = "0j009h78gw92bl61g0js6xkah76lb6gm0lv55z2sw6gxm4a1ygml";
  isLibrary = true;
  isExecutable = true;
  meta = {
    description = "Simple unicode collation as per RFC5051";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
