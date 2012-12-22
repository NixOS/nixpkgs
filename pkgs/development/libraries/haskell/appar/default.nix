{ cabal }:

cabal.mkDerivation (self: {
  pname = "appar";
  version = "0.1.4";
  sha256 = "09jb9ij78fdkz2qk66rw99q19qnm504dpv0yq0pjsl6xwjmndsjq";
  meta = {
    description = "A simple applicative parser";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
