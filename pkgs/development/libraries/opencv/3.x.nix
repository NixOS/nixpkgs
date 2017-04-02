{ lib, stdenv, fetchurl, fetchpatch, fetchFromGitHub, cmake, pkgconfig, unzip, zlib

, enableJPEG      ? true, libjpeg
, enablePNG       ? true, libpng
, enableTIFF      ? true, libtiff
, enableWebP      ? true, libwebp
, enableEXR       ? true, openexr, ilmbase
, enableJPEG2K    ? true, jasper

, enableIpp       ? false
, enableContrib   ? false, protobuf3_1
, enablePython    ? false, pythonPackages
, enableGtk2      ? false, gtk2
, enableGtk3      ? false, gtk3
, enableFfmpeg    ? false, ffmpeg
, enableGStreamer ? false, gst_all_1
, enableEigen     ? false, eigen
, enableCuda      ? false, cudatoolkit, gcc5
}:

let
  version = "3.2.0";

  src = fetchFromGitHub {
    owner  = "opencv";
    repo   = "opencv";
    rev    = version;
    sha256 = "0f59g0dvhp5xg1xa3r4lp351a7x0k03i77ylgcf69ns3y47qd16p";
  };

  contribSrc = fetchFromGitHub {
    owner  = "opencv";
    repo   = "opencv_contrib";
    rev    = version;
    sha256 = "1lynpbxz1jay3ya5y45zac5v8c6ifgk4ssn8d1chfdk3spi691jj";
  };

  vggFiles = fetchFromGitHub {
    owner  = "opencv";
    repo   = "opencv_3rdparty";
    rev    = "fccf7cd6a4b12079f73bbfb21745f9babcd4eb1d";
    sha256 = "0r9fam8dplyqqsd3qgpnnfgf9l7lj44di19rxwbm8mxiw0rlcdvy";
  };

  bootdescFiles = fetchFromGitHub {
    owner  = "opencv";
    repo   = "opencv_3rdparty";
    rev    = "34e4206aef44d50e6bbcd0ab06354b52e7466d26";
    sha256 = "13yig1xhvgghvxspxmdidss5lqiikpjr0ddm83jsi0k85j92sn62";
  };

  opencvFlag = name: enabled: "-DWITH_${name}=${if enabled then "ON" else "OFF"}";
in

stdenv.mkDerivation rec {
  name = "opencv-${version}";
  inherit version src;

  postUnpack =
    (lib.optionalString enableContrib ''
      cp --no-preserve=mode -r "${contribSrc}/modules" "$NIX_BUILD_TOP/opencv_contrib"

      for name in vgg_generated_48.i \
                  vgg_generated_64.i \
                  vgg_generated_80.i \
                  vgg_generated_120.i; do
        ln -s "${vggFiles}/$name" "$NIX_BUILD_TOP/opencv_contrib/xfeatures2d/src/$name"
      done

      for name in boostdesc_bgm.i          \
                  boostdesc_bgm_bi.i       \
                  boostdesc_bgm_hd.i       \
                  boostdesc_binboost_064.i \
                  boostdesc_binboost_128.i \
                  boostdesc_binboost_256.i \
                  boostdesc_lbgm.i; do
        ln -s "${bootdescFiles}/$name" "$NIX_BUILD_TOP/opencv_contrib/xfeatures2d/src/$name"
      done
    '');
  preConfigure =
    (let version  = "20151201";
         md5      = "808b791a6eac9ed78d32a7666804320e";
         sha256   = "1nph0w0pdcxwhdb5lxkb8whpwd9ylvwl97hn0k425amg80z86cs3";
         rev      = "81a676001ca8075ada498583e4166079e5744668";
         platform = if stdenv.system == "x86_64-linux" || stdenv.system == "i686-linux" then "linux"
                    else throw "ICV is not available for this platform (or not yet supported by this package)";
         name = "ippicv_${platform}_${version}.tgz";
         ippicv = fetchurl {
           url = "https://raw.githubusercontent.com/opencv/opencv_3rdparty/${rev}/ippicv/${name}";
           inherit sha256;
         };
         dir = "3rdparty/ippicv/downloads/${platform}-${md5}";
     in lib.optionalString enableIpp ''
          mkdir -p "${dir}"
          ln -s "${ippicv}" "${dir}/${name}"
        ''
    ) +
    (lib.optionalString enableContrib ''
      cmakeFlagsArray+=("-DOPENCV_EXTRA_MODULES_PATH=$NIX_BUILD_TOP/opencv_contrib")
    '');

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
    ++ lib.optionals enableCuda [ cudatoolkit gcc5 ]
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
  ] ++ lib.optionals enableCuda [ "-DCUDA_FAST_MATH=ON" ]
    ++ lib.optional enableContrib "-DBUILD_PROTOBUF=off";

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
