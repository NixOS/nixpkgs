{ cabal, fay }:

cabal.mkDerivation (self: {
  pname = "fay-base";
  version = "0.19.1";
  sha256 = "1b4v8l3adhcpply9yqk1pc1cgsvqlamvk60rvcb89kw5clrbvr4r";
  buildDepends = [ fay ];
  meta = {
    homepage = "https://github.com/faylang/fay-base";
    description = "The base package for Fay";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
