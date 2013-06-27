{ cabal, regexBase, regexTdfa, text }:

cabal.mkDerivation (self: {
  pname = "regex-tdfa-text";
  version = "1.0.0.2";
  sha256 = "1p17xv3j2xd74iilyqwlqhkmyp26asq4k1pb0h2f0wdqqfr87bfd";
  buildDepends = [ regexBase regexTdfa text ];
  meta = {
    description = "Text interface for regex-tdfa";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
