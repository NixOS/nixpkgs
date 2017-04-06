{
  kdeFramework, lib,
  extra-cmake-modules,
  ilmbase, karchive, qtbase
}:

kdeFramework {
  name = "kimageformats";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ ilmbase qtbase ];
  propagatedBuildInputs = [ karchive ];
  NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR";
}
