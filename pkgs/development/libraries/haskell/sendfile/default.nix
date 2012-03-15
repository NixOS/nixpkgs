{ cabal, network }:

cabal.mkDerivation (self: {
  pname = "sendfile";
  version = "0.7.5";
  sha256 = "0gkkxlbl3ci1b973jyksk03400pm8npmsqv81iqs0lwbzc7nxs28";
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
