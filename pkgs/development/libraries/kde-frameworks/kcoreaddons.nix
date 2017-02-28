{ kdeFramework, lib, fetchurl, extra-cmake-modules, qtbase, qttools, shared_mime_info }:

kdeFramework {
  name = "kcoreaddons";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules qttools ];
  buildInputs = [ qtbase ];
  propagatedBuildInputs = [ shared_mime_info ];
}
