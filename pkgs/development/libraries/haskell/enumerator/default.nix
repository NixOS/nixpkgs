{cabal, text, transformers}:

cabal.mkDerivation (self : {
  pname = "enumerator";
  version = "0.4.9.1";
  sha256 = "1rnhapj5am1rv3dff2bkhch7ikpyhs18nay39h0805xl50dcyw99";
  propagatedBuildInputs = [text transformers];
  meta = {
    description = "Reliable, high-performance processing with left-fold enumerators";
    license = "MIT";
  };
})

