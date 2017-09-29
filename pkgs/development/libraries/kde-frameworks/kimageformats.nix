{
  mkDerivation, lib,
  extra-cmake-modules,
  ilmbase, karchive, openexr, qtbase
}:

let inherit (lib) getDev; in

mkDerivation {
  name = "kimageformats";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ karchive openexr qtbase ];
  outputs = [ "out" ]; # plugins only
  NIX_CFLAGS_COMPILE = "-I${getDev ilmbase}/include/OpenEXR";
}
