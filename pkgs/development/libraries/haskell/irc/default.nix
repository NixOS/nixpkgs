{ cabal, parsec }:

cabal.mkDerivation (self: {
  pname = "irc";
  version = "0.5.0.0";
  sha256 = "0bid9iqgrppkl7hl1cd2m1pvvk5qva53fqfl0v5ld52j904c50sr";
  buildDepends = [ parsec ];
  meta = {
    description = "A small library for parsing IRC messages";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
