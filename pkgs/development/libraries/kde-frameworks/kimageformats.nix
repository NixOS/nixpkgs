{
  mkDerivation, lib,
  extra-cmake-modules,
  ilmbase, karchive, openexr, dav1d, libaom, libavif, libheif, libjxl, libraw, libyuv, qtbase
}:

let inherit (lib) getDev; in

mkDerivation {
  pname = "kimageformats";

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ karchive openexr libaom libavif dav1d libheif libjxl libraw libyuv qtbase ];
  outputs = [ "out" ]; # plugins only
  CXXFLAGS = "-I${getDev ilmbase}/include/OpenEXR";
  cmakeFlags = [
    "-DKIMAGEFORMATS_HEIF=ON"
  ];
}
