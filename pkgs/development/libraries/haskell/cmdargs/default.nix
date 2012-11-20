{ cabal, filepath, transformers }:

cabal.mkDerivation (self: {
  pname = "cmdargs";
  version = "0.10.1";
  sha256 = "0p7fzh65asn1bpzp137vfww97in2mkqfwwsk8hxzsdx32zi1nfz8";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ filepath transformers ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/cmdargs/";
    description = "Command line argument processing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
