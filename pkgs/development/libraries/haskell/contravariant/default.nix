{ cabal, tagged, transformers, transformersCompat }:

cabal.mkDerivation (self: {
  pname = "contravariant";
  version = "0.4.3";
  sha256 = "1hhcsy5bshi2yx8618wxa40gax5wfapnbgdmv1acgjyxb6vbmsp6";
  buildDepends = [ tagged transformers transformersCompat ];
  meta = {
    homepage = "http://github.com/ekmett/contravariant/";
    description = "Contravariant functors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
