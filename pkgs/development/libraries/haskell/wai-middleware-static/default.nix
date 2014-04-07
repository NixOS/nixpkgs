{ cabal, filepath, httpTypes, mtl, text, wai }:

cabal.mkDerivation (self: {
  pname = "wai-middleware-static";
  version = "0.5.0.0";
  sha256 = "0mvsm1ff7i2v09gchkc60r8klin1lb0w690m2kwhf9q6y7fxphdf";
  buildDepends = [ filepath httpTypes mtl text wai ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/scotty-web/scotty";
    description = "WAI middleware that serves requests to static files";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
