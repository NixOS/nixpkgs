{ mkDerivation, base, containers, hashable, lib, semigroupoids
, tagged, these, transformers, unordered-containers, vector
}:
mkDerivation {
  pname = "semialign";
  version = "1.1.0.1";
  sha256 = "9810bddff641bf7446a1939e5f337e368f894d06e3995a536704b3e16b241a87";
  libraryHaskellDepends = [
    base containers hashable semigroupoids tagged these transformers
    unordered-containers vector
  ];
  homepage = "https://github.com/isomorphism/these";
  description = "Align and Zip type-classes from the common Semialign ancestor";
  license = lib.licenses.bsd3;
}
