{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "uniplate";
  version = "1.6";
  sha256 = "13nlyzsnj6hshgl839ww1kp49r87kpdcdyn7hxahg8k2qkj5zzxr";
  buildDepends = [ syb ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/uniplate/";
    description = "Help writing simple, concise and fast generic operations.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
