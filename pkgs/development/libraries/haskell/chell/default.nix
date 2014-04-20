{ cabal, ansiTerminal, options, patience, random, text
, transformers
}:

cabal.mkDerivation (self: {
  pname = "chell";
  version = "0.3.3";
  sha256 = "1k5vxipf47753d41dgr1gr4zy7y72gz2x8lcn0fgfmxi2v810nsm";
  buildDepends = [
    ansiTerminal options patience random text transformers
  ];
  meta = {
    homepage = "https://john-millikin.com/software/chell/";
    description = "A simple and intuitive library for automated testing";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
