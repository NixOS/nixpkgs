{ mkDerivation, base, basement, bytestring, deepseq, foundation
, ghc-prim, lib
}:
mkDerivation {
  pname = "memory";
  version = "0.15.0";
  sha256 = "e3ff892c1a94708954d0bb2c4f4ab81bc0f505352d95095319c462db1aeb3529";
  revision = "2";
  editedCabalFile = "0fd40y5byy4cq4x6m66zxadxbw96gzswplgfyvdqnjlasq28xw68";
  libraryHaskellDepends = [
    base basement bytestring deepseq ghc-prim
  ];
  testHaskellDepends = [ base basement bytestring foundation ];
  homepage = "https://github.com/vincenthz/hs-memory";
  description = "memory and related abstraction stuff";
  license = lib.licenses.bsd3;
}
