{ cabal, c2hs, cuda }:

cabal.mkDerivation (self: {
  pname = "cufft";
  version = "0.1.0.3";
  sha256 = "1jj1ixacmhwjcb2syv4fglawpya5vmdhdk2xqrw4wwfxw4wc9ypi";
  buildDepends = [ cuda ];
  buildTools = [ c2hs ];
  meta = {
    homepage = "http://github.com/robeverest/cufft";
    description = "Haskell bindings for the CUFFT library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
