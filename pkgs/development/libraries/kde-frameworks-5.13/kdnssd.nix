{ mkDerivation, lib
, extra-cmake-modules
, avahi
}:

mkDerivation {
  name = "kdnssd";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ avahi ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
