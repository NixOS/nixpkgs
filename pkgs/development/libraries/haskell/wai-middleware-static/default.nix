{ cabal, filepath, httpTypes, mtl, text, wai }:

cabal.mkDerivation (self: {
  pname = "wai-middleware-static";
  version = "0.4.0.3";
  sha256 = "0nvzdj04g10bcay6x4y5l7gxx38gs3ns0izair8n1j1awrp8px07";
  buildDepends = [ filepath httpTypes mtl text wai ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/scotty-web/scotty";
    description = "WAI middleware that intercepts requests to static files";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
