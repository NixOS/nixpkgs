{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "uniplate";
  version = "1.6.1";
  sha256 = "0q3sjmmjfxk9hsqxcr7bzrgkgfkl725qqwkin39ln19zcq9w75v0";
  buildDepends = [ syb ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/uniplate/";
    description = "Help writing simple, concise and fast generic operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
