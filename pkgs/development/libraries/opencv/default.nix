{ lib, stdenv, fetchFromGitHub, cmake, pkgconfig, unzip
, zlib
, enablePython ? false, pythonPackages
, enableGtk2 ? false, gtk2
, enableJPEG ? true, libjpeg
, enablePNG ? true, libpng
, enableTIFF ? true, libtiff
, enableEXR ? (!stdenv.isDarwin), openexr, ilmbase
, enableJPEG2K ? true, jasper
, enableFfmpeg ? false, ffmpeg
, enableGStreamer ? false, gst_all
, enableEigen ? false, eigen
, darwin
}:

let
  opencvFlag = name: enabled: "-DWITH_${name}=${if enabled then "ON" else "OFF"}";

in

stdenv.mkDerivation rec {
  name = "opencv-${version}";
  version = "2.4.13";

  src = fetchFromGitHub {
    owner = "Itseez";
    repo = "opencv";
    rev = version;
    sha256 = "1k29rxlvrhgc5hadg2nc50wa3d2ls9ndp373257p756a0aividxh";
  };

  patches =
    [ # Don't include a copy of the CMake status output in the
      # build. This causes a runtime dependency on GCC.
      ./no-build-info.patch
    ];

  outputs = [ "out" "dev" ];

  buildInputs =
       [ zlib ]
    ++ lib.optional enablePython pythonPackages.python
    ++ lib.optional enableGtk2 gtk2
    ++ lib.optional enableJPEG libjpeg
    ++ lib.optional enablePNG libpng
    ++ lib.optional enableTIFF libtiff
    ++ lib.optionals enableEXR [ openexr ilmbase ]
    ++ lib.optional enableJPEG2K jasper
    ++ lib.optional enableFfmpeg ffmpeg
    ++ lib.optionals enableGStreamer (with gst_all; [ gstreamer gst-plugins-base ])
    ++ lib.optional enableEigen eigen
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ Cocoa QTKit ])
    ;

  propagatedBuildInputs = lib.optional enablePython pythonPackages.numpy;

  nativeBuildInputs = [ cmake pkgconfig unzip ];

  NIX_CFLAGS_COMPILE = lib.optional enableEXR "-I${ilmbase.dev}/include/OpenEXR";

  cmakeFlags = [
    (opencvFlag "TIFF" enableTIFF)
    (opencvFlag "JASPER" enableJPEG2K)
    (opencvFlag "JPEG" enableJPEG)
    (opencvFlag "PNG" enablePNG)
    (opencvFlag "OPENEXR" enableEXR)
  ];

  enableParallelBuilding = true;

  hardeningDisable = [ "bindnow" "relro" ];

  # Fix pkgconfig file that gets broken with multiple outputs
  postFixup = ''
    sed -i $dev/lib/pkgconfig/opencv.pc -e "s|includedir_old=.*|includedir_old=$dev/include/opencv|"
    sed -i $dev/lib/pkgconfig/opencv.pc -e "s|includedir_new=.*|includedir_new=$dev/include|"
  '';

  passthru = lib.optionalAttrs enablePython { pythonPath = []; };

  meta = with stdenv.lib; {
    description = "Open Computer Vision Library with more than 500 algorithms";
    homepage = http://opencv.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ viric ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
