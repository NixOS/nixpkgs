{ mkDerivation, lib
, extra-cmake-modules
}:

mkDerivation {
  name = "kitemviews";
  nativeBuildInputs = [ extra-cmake-modules ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
