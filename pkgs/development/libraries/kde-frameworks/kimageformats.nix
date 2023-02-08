{
  mkDerivation, lib,
  extra-cmake-modules,
  ilmbase, karchive, openexr, libavif, libheif, libjxl, libraw, qtbase
}:

let inherit (lib) getDev; in

mkDerivation {
  pname = "kimageformats";

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ karchive openexr libavif libheif libjxl libraw qtbase ];
  outputs = [ "out" ]; # plugins only
  CXXFLAGS = "-I${getDev ilmbase}/include/OpenEXR";
  cmakeFlags = [
    "-DKIMAGEFORMATS_HEIF=ON"
  ];

  meta = with lib; {
    broken = versionOlder qtbase.version "5.14";
  };
}
