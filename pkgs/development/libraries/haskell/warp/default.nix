{ cabal, blazeBuilder, blazeBuilderConduit, bytestringLexing
, caseInsensitive, conduit, httpTypes, liftedBase, network
, simpleSendfile, transformers, unixCompat, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "1.1.0.1";
  sha256 = "1bgjnnkqgcyj00jd4rgsnpmac0yfd1ydd6i61b252gyrr9dd0wm9";
  buildDepends = [
    blazeBuilder blazeBuilderConduit bytestringLexing caseInsensitive
    conduit httpTypes liftedBase network simpleSendfile transformers
    unixCompat wai
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "A fast, light-weight web server for WAI applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
