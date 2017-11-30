{ lib, stdenv
, fetchurl, fetchFromGitHub
, cmake, pkgconfig, unzip, zlib, pcre, hdf5
, config

, enableJPEG      ? true, libjpeg
, enablePNG       ? true, libpng
, enableTIFF      ? true, libtiff
, enableWebP      ? true, libwebp
, enableEXR ? (!stdenv.isDarwin), openexr, ilmbase
, enableJPEG2K    ? true, jasper
, enableEigen     ? true, eigen
, enableOpenblas  ? true, openblas

, enableCuda      ? (config.cudaSupport or false), cudatoolkit

, enableIpp       ? false
, enableContrib   ? false  #, caffe, glog, boost, google-gflags
, enablePython    ? false, pythonPackages
, enableGtk2      ? false, gtk2
, enableGtk3      ? false, gtk3
, enableFfmpeg    ? false, ffmpeg
, enableGStreamer ? false, gst_all_1
, enableTesseract ? false, tesseract, leptonica
, enableDocs      ? false, doxygen, graphviz-nox

, AVFoundation, Cocoa, QTKit
}:

let
  version = "3.3.1";

  src = fetchFromGitHub {
    owner  = "opencv";
    repo   = "opencv";
    rev    = version;
    sha256 = "1jq8nny78gp54yjgsnb2rdp5rwhp78b3r2i36b2vyx6xk6h6wwji";
  };

  contribSrc = fetchFromGitHub {
    owner  = "opencv";
    repo   = "opencv_contrib";
    rev    = version;
    sha256 = "0q5vsa8dpa3mdhzas0ckagwh2sbckpm1kxsp0i3yfknsr5ampyi2";
  };

  # Contrib must be built in order to enable Tesseract support:
  buildContrib = enableContrib || enableTesseract;

  # See opencv/3rdparty/ippicv/ippicv.cmake
  ippicv = {
    src = fetchFromGitHub {
      owner  = "opencv";
      repo   = "opencv_3rdparty";
      rev    = "dfe3162c237af211e98b8960018b564bc209261d";
      sha256 = "1k5xiwdi5r2y3fs5g70lpknxqi4pj32w6l311gfwng3q1cb2crif";
    } + "/ippicv";
    files = let name = platform : "ippicv_2017u3_${platform}_general_20170822.tgz"; in
      if stdenv.system == "x86_64-linux" then
      { ${name "lnx_intel64"} = "4e0352ce96473837b1d671ce87f17359"; }
      else if stdenv.system == "i686-linux" then
      { ${name "lnx_ia32"}    = "dcdb0ba4b123f240596db1840cd59a76"; }
      else if stdenv.system == "x86_64-darwin" then
      { ${name "mac_intel64"} = "c1ebb5dfa5b7f54b0c44e1917805a463"; }
      else
      throw "ICV is not available for this platform (or not yet supported by this package)";
    dst = ".cache/ippicv";
  };

  # See opencv_contrib/modules/xfeatures2d/cmake/download_vgg.cmake
  vgg = {
    src = fetchFromGitHub {
      owner  = "opencv";
      repo   = "opencv_3rdparty";
      rev    = "fccf7cd6a4b12079f73bbfb21745f9babcd4eb1d";
      sha256 = "0r9fam8dplyqqsd3qgpnnfgf9l7lj44di19rxwbm8mxiw0rlcdvy";
    };
    files = {
      "vgg_generated_48.i"  = "e8d0dcd54d1bcfdc29203d011a797179";
      "vgg_generated_64.i"  = "7126a5d9a8884ebca5aea5d63d677225";
      "vgg_generated_80.i"  = "7cd47228edec52b6d82f46511af325c5";
      "vgg_generated_120.i" = "151805e03568c9f490a5e3a872777b75";
    };
    dst = ".cache/xfeatures2d/vgg";
  };

  # See opencv_contrib/modules/xfeatures2d/cmake/download_boostdesc.cmake
  boostdesc = {
    src = fetchFromGitHub {
      owner  = "opencv";
      repo   = "opencv_3rdparty";
      rev    = "34e4206aef44d50e6bbcd0ab06354b52e7466d26";
      sha256 = "13yig1xhvgghvxspxmdidss5lqiikpjr0ddm83jsi0k85j92sn62";
    };
    files = {
      "boostdesc_bgm.i"          = "0ea90e7a8f3f7876d450e4149c97c74f";
      "boostdesc_bgm_bi.i"       = "232c966b13651bd0e46a1497b0852191";
      "boostdesc_bgm_hd.i"       = "324426a24fa56ad9c5b8e3e0b3e5303e";
      "boostdesc_binboost_064.i" = "202e1b3e9fec871b04da31f7f016679f";
      "boostdesc_binboost_128.i" = "98ea99d399965c03d555cef3ea502a0b";
      "boostdesc_binboost_256.i" = "e6dcfa9f647779eb1ce446a8d759b6ea";
      "boostdesc_lbgm.i"         = "0ae0675534aa318d9668f2a179c2a052";
    };
    dst = ".cache/xfeatures2d/boostdesc";
  };

  # See opencv/cmake/OpenCVDownload.cmake
  installExtraFiles = extra : with lib; ''
    mkdir -p "${extra.dst}"
  '' + concatStrings (mapAttrsToList (name : md5 : ''
    ln -s "${extra.src}/${name}" "${extra.dst}/${md5}-${name}"
  '') extra.files);

  # See opencv_contrib/modules/dnn_modern/CMakeLists.txt
  tinyDnn = rec {
    src = fetchurl {
      url    = "https://github.com/tiny-dnn/tiny-dnn/archive/${name}";
      sha256 = "12x1b984cn0psn6kz1fy75zljgzqvkdyjy8i292adfnyqpl1rip2";
    };
    name = "v1.0.0a3.tar.gz";
    md5  = "adb1c512e09ca2c7a6faef36f9c53e59";
    dst  = ".cache/tiny_dnn";
  };

  opencvFlag = name: enabled: "-DWITH_${name}=${if enabled then "ON" else "OFF"}";

in

stdenv.mkDerivation rec {
  name = "opencv-${version}";
  inherit version src;

  postUnpack = lib.optionalString buildContrib ''
    cp --no-preserve=mode -r "${contribSrc}/modules" "$NIX_BUILD_TOP/opencv_contrib"
  '';

  # This prevents cmake from using libraries in impure paths (which
  # causes build failure on non NixOS)
  # Also, work around https://github.com/NixOS/nixpkgs/issues/26304 with
  # what appears to be some stray headers in dnn/misc/tensorflow
  # in contrib when generating the Python bindings:
  postPatch = ''
    sed -i '/Add these standard paths to the search paths for FIND_LIBRARY/,/^\s*$/{d}' CMakeLists.txt
    sed -i -e 's|if len(decls) == 0:|if len(decls) == 0 or "opencv2/" not in hdr:|' ./modules/python/src2/gen2.py
  '';

  preConfigure =
    installExtraFiles ippicv + (
    lib.optionalString buildContrib ''
      cmakeFlagsArray+=("-DOPENCV_EXTRA_MODULES_PATH=$NIX_BUILD_TOP/opencv_contrib")

      ${installExtraFiles vgg}
      ${installExtraFiles boostdesc}

      mkdir -p "${tinyDnn.dst}"
      ln -s "${tinyDnn.src}" "${tinyDnn.dst}/${tinyDnn.md5}-${tinyDnn.name}"
    '');

  buildInputs =
       [ zlib pcre hdf5 ]
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
    ++ lib.optional enableOpenblas openblas
    # There is seemingly no compile-time flag for Tesseract.  It's
    # simply enabled automatically if contrib is built, and it detects
    # tesseract & leptonica.
    ++ lib.optionals enableTesseract [ tesseract leptonica ]
    ++ lib.optional enableCuda cudatoolkit

    # These are only needed for the currently disabled
    # cnn_3dobj and dnn_modern modules
    # ++ lib.optionals buildContrib [ caffe glog boost google-gflags ]

    ++ lib.optionals stdenv.isDarwin [ AVFoundation Cocoa QTKit ]
    ++ lib.optionals enableDocs [ doxygen graphviz-nox ];

  propagatedBuildInputs = lib.optional enablePython pythonPackages.numpy;

  nativeBuildInputs = [ cmake pkgconfig unzip ];

  NIX_CFLAGS_COMPILE = lib.optional enableEXR "-I${ilmbase.dev}/include/OpenEXR";

  cmakeFlags = [
    "-DWITH_OPENMP=ON"
    (opencvFlag "IPP" enableIpp)
    (opencvFlag "TIFF" enableTIFF)
    (opencvFlag "JASPER" enableJPEG2K)
    (opencvFlag "WEBP" enableWebP)
    (opencvFlag "JPEG" enableJPEG)
    (opencvFlag "PNG" enablePNG)
    (opencvFlag "OPENEXR" enableEXR)
    (opencvFlag "CUDA" enableCuda)
    (opencvFlag "CUBLAS" enableCuda)
  ] ++ lib.optionals enableCuda [
    "-DCUDA_FAST_MATH=ON"
    "-DCUDA_HOST_COMPILER=${cudatoolkit.cc}/bin/gcc"
  ] ++ lib.optionals buildContrib [
         # the cnn_3dobj module fails to build
         "-DBUILD_opencv_cnn_3dobj=OFF"

         # the dnn_modern module causes:
         # https://github.com/opencv/opencv_contrib/issues/823
         #
         # On OS X its dependency tiny-dnn-1.0.0a3 also fails to build.
         "-DBUILD_opencv_dnn_modern=OFF"
       ]
    ++ lib.optionals stdenv.isDarwin ["-DWITH_OPENCL=OFF" "-DWITH_LAPACK=OFF"];

  enableParallelBuilding = true;

  postBuild = lib.optionalString enableDocs ''
    make doxygen
  '';

  hardeningDisable = [ "bindnow" "relro" ];

  passthru = lib.optionalAttrs enablePython { pythonPath = []; };

  meta = {
    description = "Open Computer Vision Library with more than 500 algorithms";
    homepage = http://opencv.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [viric mdaiter basvandijk];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
