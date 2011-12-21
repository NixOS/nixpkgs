{ cabal, multirec }:

cabal.mkDerivation (self: {
  pname = "zipper";
  version = "0.4";
  sha256 = "0s3gw883kwxgmz9sk3638ba8i1zb5dirv2hanc3caf6pfay6caks";
  buildDepends = [ multirec ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/GenericProgramming/Multirec";
    description = "Generic zipper for families of recursive datatypes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
