{ cabal, accelerate, binary, blazeBuilder, cryptohash, cuda
, fclabels, filepath, hashable, hashtables, languageCQuote
, mainlandPretty, mtl, srcloc, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "accelerate-cuda";
  version = "0.12.1.1";
  sha256 = "1kj9i6djjb46ad3dnzk72mf33r8h1mjxljs7x5rf2d658hqk5yfv";
  buildDepends = [
    accelerate binary blazeBuilder cryptohash cuda fclabels filepath
    hashable hashtables languageCQuote mainlandPretty mtl srcloc
    transformers unorderedContainers
  ];
  patchPhase = ''
    sed -i -e 's|\<defaultMain\>|defaultMainWithHooks autoconfUserHooks|' Setup.hs
  '';
  meta = {
    homepage = "http://www.cse.unsw.edu.au/~chak/project/accelerate/";
    description = "Accelerate backend for NVIDIA GPUs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.none;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
