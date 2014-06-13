{ cabal, wai }:

cabal.mkDerivation (self: {
  pname = "wai-test";
  version = "3.0.0";
  sha256 = "0xys01jniib0pnhadcm7s0v5z0wcxfgi0bf5ax808zm9qzvl3xfx";
  buildDepends = [ wai ];
  noHaddock = true;
  meta = {
    homepage = "http://www.yesodweb.com/book/web-application-interface";
    description = "Unit test framework (built on HUnit) for WAI applications. (deprecated)";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
