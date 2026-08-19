{ mkDerivation, base, fetchzip, lib }:
mkDerivation {
  pname = "array";
  version = "0.5.8.0";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/array-0.5.8.0/array-0.5.8.0.tar.gz";
    sha256 = "01kkcc565gzkalkv9f8jd4gwbcr4j10nrl6yfppqkslgrikgwqv0";
  };
  libraryHaskellDepends = [ base ];
  description = "Mutable and immutable arrays";
  license = lib.licenses.bsd3;
}
