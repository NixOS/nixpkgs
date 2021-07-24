{ mkDerivation, base, inspection-testing, lib, transformers }:
mkDerivation {
  pname = "ap-normalize";
  version = "0.1.0.1";
  sha256 = "820613b12ce759c8c8a254c78a0e4c474b2cd4cfd08fc0c1d4d5584c58ff2288";
  libraryHaskellDepends = [ base ];
  testHaskellDepends = [ base inspection-testing transformers ];
  description = "Self-normalizing applicative expressions";
  license = lib.licenses.mit;
}
