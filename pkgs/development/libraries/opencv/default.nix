{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, unzip
, zlib
, enablePython ? false, pythonPackages
, enableGtk2 ? false, gtk2
, enableJPEG ? true, libjpeg
, enablePNG ? true, libpng
, enableTIFF ? true, libtiff
, enableEXR ? (!stdenv.isDarwin), openexr, ilmbase
, enableFfmpeg ? false, ffmpeg
, enableGStreamer ? false, gst_all_1
, enableEigen ? true, eigen
, Cocoa, QTKit
}:

let
  opencvFlag = name: enabled: "-DWITH_${name}=${if enabled then "ON" else "OFF"}";

in

stdenv.mkDerivation rec {
  pname = "opencv";
  version = "2.4.13.7";

  src = fetchFromGitHub {
    owner = "opencv";
    repo = "opencv";
    rev = version;
    sha256 = "062js7zhh4ixi2wk61wyi23qp9zsk5vw24iz2i5fab2hp97y5zq3";
  };

  patches =
    [ # Don't include a copy of the CMake status output in the
      # build. This causes a runtime dependency on GCC.
      ./no-build-info.patch
    ];

  # This prevents cmake from using libraries in impure paths (which causes build failure on non NixOS)
  postPatch = ''
    sed -i '/Add these standard paths to the search paths for FIND_LIBRARY/,/^\s*$/{d}' CMakeLists.txt
  '';

  outputs = [ "out" "dev" ];

  buildInputs =
       [ zlib ]
    ++ lib.optional enablePython pythonPackages.python
    ++ lib.optional enableGtk2 gtk2
    ++ lib.optional enableJPEG libjpeg
    ++ lib.optional enablePNG libpng
    ++ lib.optional enableTIFF libtiff
    ++ lib.optionals enableEXR [ openexr ilmbase ]
    ++ lib.optional enableFfmpeg ffmpeg
    ++ lib.optionals enableGStreamer (with gst_all_1; [ gstreamer gst-plugins-base ])
    ++ lib.optional enableEigen eigen
    ++ lib.optionals stdenv.isDarwin [ Cocoa QTKit ]
    ;

  propagatedBuildInputs = lib.optional enablePython pythonPackages.numpy;

  nativeBuildInputs = [ cmake pkg-config unzip ];

  NIX_CFLAGS_COMPILE = lib.optionalString enableEXR "-I${ilmbase.dev}/include/OpenEXR";

  cmakeFlags = [
    (opencvFlag "TIFF" enableTIFF)
    (opencvFlag "JPEG" enableJPEG)
    (opencvFlag "PNG" enablePNG)
    (opencvFlag "OPENEXR" enableEXR)
    (opencvFlag "GSTREAMER" enableGStreamer)
  ];

  hardeningDisable = [ "bindnow" "relro" ];

  # Fix pkg-config file that gets broken with multiple outputs
  postFixup = ''
    sed -i $dev/lib/pkgconfig/opencv.pc -e "s|includedir_old=.*|includedir_old=$dev/include/opencv|"
    sed -i $dev/lib/pkgconfig/opencv.pc -e "s|includedir_new=.*|includedir_new=$dev/include|"
  '';

  passthru = lib.optionalAttrs enablePython { pythonPath = []; };

  meta = with lib; {
    description = "Open Computer Vision Library with more than 500 algorithms";
    homepage = "https://opencv.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
