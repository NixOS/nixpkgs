{ cabal, filepath, httpTypes, mtl, text, wai }:

cabal.mkDerivation (self: {
  pname = "wai-middleware-static";
  version = "0.4.0.2";
  sha256 = "0nw54h8baphjdwsd118g9j5w4g2mnb2hrny0n4ih4jlqlcqam3lf";
  buildDepends = [ filepath httpTypes mtl text wai ];
  meta = {
    homepage = "https://github.com/scotty-web/scotty";
    description = "WAI middleware that intercepts requests to static files";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
