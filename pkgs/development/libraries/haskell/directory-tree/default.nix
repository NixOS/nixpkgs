{ cabal, filepath }:

cabal.mkDerivation (self: {
  pname = "directory-tree";
  version = "0.10.1";
  sha256 = "02acmfdw1yjb0h9dpjy04xxclsasm1p0m6w1dvccd4x2aqc6ybbw";
  buildDepends = [ filepath ];
  meta = {
    homepage = "http://coder.bsimmons.name/blog/2009/05/directory-tree-module-released/";
    description = "A simple directory-like tree datatype, with useful IO functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
