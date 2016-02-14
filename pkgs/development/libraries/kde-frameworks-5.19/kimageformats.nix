{ kdeFramework, lib
, extra-cmake-modules
, ilmbase
}:

kdeFramework {
  name = "kimageformats";
  nativeBuildInputs = [ extra-cmake-modules ];
  NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
