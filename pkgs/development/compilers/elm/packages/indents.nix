{ mkDerivation, base, concatenative, mtl, parsec, stdenv }:
mkDerivation {
  pname = "indents";
  version = "0.3.3";
  sha256 = "b61f51ac894609cb5571cc3ded12db5de97185a8de236c69ec24c87457109f9a";
  libraryHaskellDepends = [ base concatenative mtl parsec ];
  doCheck = false;
  homepage = "http://patch-tag.com/r/salazar/indents";
  description = "indentation sensitive parser-combinators for parsec";
  license = stdenv.lib.licenses.bsd3;
}
