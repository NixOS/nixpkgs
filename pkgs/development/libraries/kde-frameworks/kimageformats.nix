{
  mkDerivation, lib,
  extra-cmake-modules,
  ilmbase, karchive, qtbase
}:

mkDerivation {
  name = "kimageformats";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ ilmbase qtbase ];
  propagatedBuildInputs = [ karchive ];
  NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR";
}
