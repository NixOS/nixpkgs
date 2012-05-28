{ cabal, deepseq, mtl, parallel, parsec, terminfo, utf8String
, vector
}:

cabal.mkDerivation (self: {
  pname = "vty";
  version = "4.7.0.14";
  sha256 = "0wgn2jbr7lih9znkpa09nvb4qjd0801c0r4mwwrw4pd9n9mkjqn9";
  buildDepends = [
    deepseq mtl parallel parsec terminfo utf8String vector
  ];
  meta = {
    homepage = "https://github.com/coreyoconnor/vty";
    description = "A simple terminal access library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
