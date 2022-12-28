{ mkDerivation, lib
, extra-cmake-modules
, kcodecs
}:

mkDerivation {
  pname = "syndication";
  meta.maintainers = [ lib.maintainers.bkchr ];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcodecs ];
}
