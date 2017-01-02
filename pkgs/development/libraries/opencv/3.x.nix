{ lib, stdenv, fetchurl, fetchpatch, fetchFromGitHub, cmake, pkgconfig, unzip
, zlib
, enableIpp ? false
, enableContrib ? false, protobuf3_1
, enablePython ? false, pythonPackages
, enableGtk2 ? false, gtk2
, enableGtk3 ? false, gtk3
, enableJPEG ? true, libjpeg
, enablePNG ? true, libpng
, enableTIFF ? true, libtiff
, enableWebP ? true, libwebp
, enableEXR ? true, openexr, ilmbase
, enableJPEG2K ? true, jasper
, enableFfmpeg ? false, ffmpeg
, enableGStreamer ? false, gst_all_1
, enableEigen ? false, eigen
, enableCuda ? false, cudatoolkit, gcc5
}:

let
  version = "3.2.0";

  contribSrc = fetchFromGitHub {
    owner = "Itseez";
    repo = "opencv_contrib";
    rev = version;
    sha256 = "1lynpbxz1jay3ya5y45zac5v8c6ifgk4ssn8d1chfdk3spi691jj";
  };

  opencvFlag = name: enabled: "-DWITH_${name}=${if enabled then "ON" else "OFF"}";

in

stdenv.mkDerivation rec {
  name = "opencv-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "Itseez";
    repo = "opencv";
    rev = version;
    sha256 = "0f59g0dvhp5xg1xa3r4lp351a7x0k03i77ylgcf69ns3y47qd16p";
  };

  preConfigure =
    let ippicvVersion = "20151201";
        ippicvPlatform = if stdenv.system == "x86_64-linux" || stdenv.system == "i686-linux" then "linux"
                         else throw "ICV is not available for this platform (or not yet supported by this package)";
        ippicvHash = if ippicvPlatform == "linux" then "1nph0w0pdcxwhdb5lxkb8whpwd9ylvwl97hn0k425amg80z86cs3"
                     else throw "ippicvHash: impossible";

        ippicvName = "ippicv_${ippicvPlatform}_${ippicvVersion}.tgz";
        ippicvArchive = "3rdparty/ippicv/downloads/linux-${ippicvHash}/${ippicvName}";
        ippicv = fetchurl {
          url = "https://github.com/Itseez/opencv_3rdparty/raw/ippicv/master_${ippicvVersion}/ippicv/${ippicvName}";
          sha256 = ippicvHash;
        };
    in lib.optionalString enableIpp
      ''
        mkdir -p $(dirname ${ippicvArchive})
        ln -s ${ippicv}    ${ippicvArchive}
      '';

  buildInputs =
       [ zlib ]
    ++ lib.optional enablePython pythonPackages.python
    ++ lib.optional enableGtk2 gtk2
    ++ lib.optional enableGtk3 gtk3
    ++ lib.optional enableJPEG libjpeg
    ++ lib.optional enablePNG libpng
    ++ lib.optional enableTIFF libtiff
    ++ lib.optional enableWebP libwebp
    ++ lib.optionals enableEXR [ openexr ilmbase ]
    ++ lib.optional enableJPEG2K jasper
    ++ lib.optional enableFfmpeg ffmpeg
    ++ lib.optionals enableGStreamer (with gst_all_1; [ gstreamer gst-plugins-base ])
    ++ lib.optional enableEigen eigen
    ++ lib.optional enableCuda [ cudatoolkit gcc5 ]
    ++ lib.optional enableContrib protobuf3_1
    ;

  propagatedBuildInputs = lib.optional enablePython pythonPackages.numpy;

  nativeBuildInputs = [ cmake pkgconfig unzip ];

  NIX_CFLAGS_COMPILE = lib.optional enableEXR "-I${ilmbase.dev}/include/OpenEXR";

  cmakeFlags = [
    "-DWITH_IPP=${if enableIpp then "ON" else "OFF"}"
    (opencvFlag "TIFF" enableTIFF)
    (opencvFlag "JASPER" enableJPEG2K)
    (opencvFlag "WEBP" enableWebP)
    (opencvFlag "JPEG" enableJPEG)
    (opencvFlag "PNG" enablePNG)
    (opencvFlag "OPENEXR" enableEXR)
    (opencvFlag "CUDA" enableCuda)
    (opencvFlag "CUBLAS" enableCuda)
  ] ++ lib.optionals enableContrib [
    "-DOPENCV_EXTRA_MODULES_PATH=${contribSrc}/modules"
    # some contrib modules are badly behaved and attempt to download 3rd party libs as part of the build process:
    "-DBUILD_PROTOBUF=OFF"            # the dnn module would otherwise attempt to download protobuf src
    "-DBUILD_opencv_xfeatures2d=OFF"  # attempts to download VGG and boostdesc image descriptor trained models
  ] ++ lib.optionals enableCuda [ "-DCUDA_FAST_MATH=ON" ];

  enableParallelBuilding = true;

  hardeningDisable = [ "bindnow" "relro" ];

  passthru = lib.optionalAttrs enablePython { pythonPath = []; };

  meta = {
    description = "Open Computer Vision Library with more than 500 algorithms";
    homepage = http://opencv.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [viric flosse mdaiter];
    platforms = with stdenv.lib.platforms; linux;
  };
}
