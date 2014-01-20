{ cabal, base64Bytestring, cairo, filepath, gd, hoodleTypes, lens
, monadLoops, mtl, poppler, strict, svgcairo, uuid
}:

cabal.mkDerivation (self: {
  pname = "hoodle-render";
  version = "0.3.2";
  sha256 = "1mmx27g1vqpndk26nz2hy7rckcgg68clvr5x31cqz9f8sifd8rsg";
  buildDepends = [
    base64Bytestring cairo filepath gd hoodleTypes lens monadLoops mtl
    poppler strict svgcairo uuid
  ];
  jailbreak = true;
  meta = {
    description = "Hoodle file renderer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ianwookim ];
  };
})
