{ kdeFramework, lib
, extra-cmake-modules
, ilmbase
}:

kdeFramework {
  name = "kimageformats";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR";
}
