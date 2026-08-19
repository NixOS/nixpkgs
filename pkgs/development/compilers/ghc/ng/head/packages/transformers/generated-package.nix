{ mkDerivation, base, fetchzip, lib }:
mkDerivation {
  pname = "transformers";
  version = "0.6.1.2";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/transformers-0.6.1.2/transformers-0.6.1.2.tar.gz";
    sha256 = "1hyqi74hamb9cry60r7i4l62ml2rbn2agrkmzav4bqznmfwz097w";
  };
  libraryHaskellDepends = [ base ];
  description = "Concrete functor and monad transformers";
  license = lib.licenses.bsd3;
}
