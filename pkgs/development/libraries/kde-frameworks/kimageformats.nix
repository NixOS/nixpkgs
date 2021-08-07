{
  mkDerivation, lib,
  extra-cmake-modules,
  ilmbase, karchive, openexr, libavif, qtbase
}:

let inherit (lib) getDev; in

mkDerivation {
  name = "kimageformats";

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ karchive openexr libavif qtbase ];
  outputs = [ "out" ]; # plugins only
  CXXFLAGS = "-I${getDev ilmbase}/include/OpenEXR";

  meta = with lib; {
    broken = versionOlder qtbase.version "5.14";
  };
}
