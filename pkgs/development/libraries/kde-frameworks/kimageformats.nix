{ kdeFramework, lib
, ecm
, ilmbase
}:

kdeFramework {
  name = "kimageformats";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR";
}
