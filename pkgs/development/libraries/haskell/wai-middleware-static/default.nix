{ cabal, filepath, httpTypes, mtl, text, wai }:

cabal.mkDerivation (self: {
  pname = "wai-middleware-static";
  version = "0.5.0.1";
  sha256 = "1pwyy6lsvi7kaxf6x3ghy5013yq4ryjp01c4rrd4isx4jh1ynl31";
  buildDepends = [ filepath httpTypes mtl text wai ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/scotty-web/scotty";
    description = "WAI middleware that serves requests to static files";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
