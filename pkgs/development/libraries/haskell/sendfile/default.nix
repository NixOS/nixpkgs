{ cabal, network }:

cabal.mkDerivation (self: {
  pname = "sendfile";
  version = "0.7.3";
  sha256 = "0xa5ryyznw7cizdqjnisvyhirdljw5z7aydwv5m9lv9hkx3bs6l0";
  buildDepends = [ network ];
  meta = {
    homepage = "http://patch-tag.com/r/mae/sendfile";
    description = "A portable sendfile library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
