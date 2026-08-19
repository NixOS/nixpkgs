{ mkDerivation, base, fetchzip, lib, transformers }:
mkDerivation {
  pname = "mtl";
  version = "2.3.1";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/mtl-2.3.1/mtl-2.3.1.tar.gz";
    sha256 = "0mrh1n5i1d00rslrjwj8fvnfjpsjx6aswixa93bx6v94kxlkkakh";
  };
  libraryHaskellDepends = [ base transformers ];
  homepage = "http://github.com/haskell/mtl";
  description = "Monad classes for transformers, using functional dependencies";
  license = lib.meta.getLicenseFromSpdxId "BSD-3-Clause";
}
