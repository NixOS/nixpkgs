{ cabal, Cabal, filepath }:

cabal.mkDerivation (self: {
  pname = "directory-tree";
  version = "0.10.0";
  sha256 = "08b0w9j55x6c06pri7yvv84n24inhpb4miybdnkyjkjy7r3yy7m4";
  buildDepends = [ Cabal filepath ];
  meta = {
    homepage = "http://coder.bsimmons.name/blog/2009/05/directory-tree-module-released/";
    description = "A simple directory-like tree datatype, with useful IO functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
