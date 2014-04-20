{ cabal, haskellSrcMeta, text }:

cabal.mkDerivation (self: {
  pname = "interpolatedstring-perl6";
  version = "0.9.0";
  sha256 = "15hzmni3wfdgjl0vyk5mcld61ba99wdax87s7wkz2s8bsyxkbq9n";
  buildDepends = [ haskellSrcMeta text ];
  meta = {
    description = "QuasiQuoter for Perl6-style multi-line interpolated strings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
