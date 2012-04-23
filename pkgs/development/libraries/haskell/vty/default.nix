{ cabal, deepseq, mtl, parallel, parsec, terminfo, utf8String
, vector
}:

cabal.mkDerivation (self: {
  pname = "vty";
  version = "4.7.0.12";
  sha256 = "0mmx8rhj6k8c56qhaz7ay2yf9x61h27zxs14mrkw2y4qag6d4bii";
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
