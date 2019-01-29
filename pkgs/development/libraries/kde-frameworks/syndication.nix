{ mkDerivation, lib
, extra-cmake-modules
, kcodecs
}:

mkDerivation {
  name = "syndication";
  meta = {
    maintainers = [ lib.maintainers.bkchr ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcodecs ];
}
