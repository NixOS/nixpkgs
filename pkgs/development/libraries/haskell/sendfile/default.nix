{ cabal, network }:

cabal.mkDerivation (self: {
  pname = "sendfile";
  version = "0.7.8";
  sha256 = "0xy9ciikr444gblh3r8z3w4h4rcrfjfciw3dvxgzbygqs5dy6yxl";
  buildDepends = [ network ];
  meta = {
    homepage = "http://hub.darcs.net/stepcut/sendfile";
    description = "A portable sendfile library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
