{ cabal, fay }:

cabal.mkDerivation (self: {
  pname = "fay-base";
  version = "0.19.1.2";
  sha256 = "0y2gpyh0gama6mz0rfvqdgpf7wfwx7r8k0cdfh60kjcxr029dx5i";
  buildDepends = [ fay ];
  meta = {
    homepage = "https://github.com/faylang/fay-base";
    description = "The base package for Fay";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
