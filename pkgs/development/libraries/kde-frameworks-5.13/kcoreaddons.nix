{ mkDerivation, lib
, extra-cmake-modules
, shared_mime_info
}:

mkDerivation {
  name = "kcoreaddons";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ shared_mime_info ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
