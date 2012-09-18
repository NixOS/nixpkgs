{ cabal }:

cabal.mkDerivation (self: {
  pname = "vcs-revision";
  version = "0.0.1";
  sha256 = "1zfv9b02ml8622kz755azhi4ajyxrqniiachd92znfrry4n8z1mn";
  meta = {
    description = "Facilities for accessing the version control revision of the current directory";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
