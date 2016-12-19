{
  kdeFramework, lib,
  ecm,
  ilmbase, karchive
}:

kdeFramework {
  name = "kimageformats";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  buildInputs = [ ilmbase ];
  propagatedBuildInputs = [ karchive ];
  NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR";
}
