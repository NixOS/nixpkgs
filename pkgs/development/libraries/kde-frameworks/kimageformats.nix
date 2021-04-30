{
  mkDerivation, lib,
  extra-cmake-modules,
  ilmbase, karchive, openexr, qtbase
}:

let inherit (lib) getDev; in

mkDerivation {
  name = "kimageformats";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ karchive openexr qtbase ];
  outputs = [ "out" ]; # plugins only
  env.CXXFLAGS = "-I${getDev ilmbase}/include/OpenEXR";
}
