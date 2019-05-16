{ lib, stdenv
, fetchurl, fetchFromGitHub, fetchpatch
, cmake, pkgconfig, unzip, zlib, pcre, hdf5
, glog, boost, google-gflags, protobuf
, config

, enableJPEG      ? true, libjpeg
, enablePNG       ? true, libpng
, enableTIFF      ? true, libtiff
, enableWebP      ? true, libwebp
, enableEXR ?     !stdenv.isDarwin, openexr, ilmbase
, enableJPEG2K    ? true, jasper
, enableEigen     ? true, eigen
, enableOpenblas  ? true, openblas
, enableContrib   ? true

, enableCuda      ? config.cudaSupport or false, cudatoolkit

, enableUnfree    ? false
, enableIpp       ? false
, enablePython    ? false, pythonPackages
, enableGtk2      ? false, gtk2
, enableGtk3      ? false, gtk3
, enableVtk       ? false, vtk
, enableFfmpeg    ? false, ffmpeg
, enableGStreamer ? false, gst_all_1
, enableTesseract ? false, tesseract, leptonica
, enableTbb       ? false, tbb
, enableOvis      ? false, ogre
, enableGPhoto2   ? false, libgphoto2
, enableDC1394    ? false, libdc1394
, enableDocs      ? false, doxygen, graphviz-nox

, cf-private, AVFoundation, Cocoa, QTKit, VideoDecodeAcceleration, bzip2
}:

let
  version = "3.4.5";

  src = fetchFromGitHub {
    owner  = "opencv";
    repo   = "opencv";
    rev    = version;
    sha256 = "0hz9316ys2qi0lx9dcbsk3mkn8cn08q12hc96p6zz2d4is6d5wsc";
  };

  contribSrc = fetchFromGitHub {
    owner  = "opencv";
    repo   = "opencv_contrib";
    rev    = version;
    sha256 = "1fw7qwgibiznqal2dg4alkw8hrrrpjc0jaicf2406604rjm2lx6h";
  };

  # Contrib must be built in order to enable Tesseract support:
  buildContrib = enableContrib || enableTesseract;

  useSystemProtobuf = ! stdenv.isDarwin;

  # See opencv/3rdparty/ippicv/ippicv.cmake
  ippicv = {
    src = fetchFromGitHub {
      owner  = "opencv";
      repo   = "opencv_3rdparty";
      rev    = "bdb7bb85f34a8cb0d35e40a81f58da431aa1557a";
      sha256 = "1ys9mshfpm8iy8h4ml792gnqrq959dsrcv26axx14niivxyjbji8";
    } + "/ippicv";
    files = let name = platform : "ippicv_2017u3_${platform}_general_20180518.tgz"; in
      if stdenv.hostPlatform.system == "x86_64-linux" then
      { ${name "lnx_intel64"} = "b7cc351267db2d34b9efa1cd22ff0572"; }
      else if stdenv.hostPlatform.system == "i686-linux" then
      { ${name "lnx_ia32"}    = "ea72de74dae3c604eb6348395366e78e"; }
      else if stdenv.hostPlatform.system == "x86_64-darwin" then
      { ${name "mac_intel64"} = "3ae52b9be0fe73dd45bc5e9429cd3732"; }
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

  # See opencv_contrib/modules/face/CMakeLists.txt
  face = {
    src = fetchFromGitHub {
      owner  = "opencv";
      repo   = "opencv_3rdparty";
      rev    = "8afa57abc8229d611c4937165d20e2a2d9fc5a12";
      sha256 = "061lsvqdidq9xa2hwrcvwi9ixflr2c2lfpc8drr159g68zi8bp4v";
    };
    files = {
      "face_landmark_model.dat" = "7505c44ca4eb54b4ab1e4777cb96ac05";
    };
    dst = ".cache/data";
  };

  # See opencv/cmake/OpenCVDownload.cmake
  installExtraFiles = extra : with lib; ''
    mkdir -p "${extra.dst}"
  '' + concatStrings (mapAttrsToList (name : md5 : ''
    ln -s "${extra.src}/${name}" "${extra.dst}/${md5}-${name}"
  '') extra.files);

  opencvFlag = name: enabled: "-DWITH_${name}=${printEnabled enabled}";

  printEnabled = enabled : if enabled then "ON" else "OFF";
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
    lib.optionalString enableIpp (installExtraFiles ippicv) + (
    lib.optionalString buildContrib ''
      cmakeFlagsArray+=("-DOPENCV_EXTRA_MODULES_PATH=$NIX_BUILD_TOP/opencv_contrib")

      ${installExtraFiles vgg}
      ${installExtraFiles boostdesc}
      ${installExtraFiles face}
    '');

  postConfigure = ''
    [ -e modules/core/version_string.inc ]
    echo '"(build info elided)"' > modules/core/version_string.inc
  '';

  buildInputs =
       [ zlib pcre hdf5 glog boost google-gflags ]
    ++ lib.optional useSystemProtobuf protobuf
    ++ lib.optional enablePython pythonPackages.python
    ++ lib.optional enableGtk2 gtk2
    ++ lib.optional enableGtk3 gtk3
    ++ lib.optional enableVtk vtk
    ++ lib.optional enableJPEG libjpeg
    ++ lib.optional enablePNG libpng
    ++ lib.optional enableTIFF libtiff
    ++ lib.optional enableWebP libwebp
    ++ lib.optionals enableEXR [ openexr ilmbase ]
    ++ lib.optional enableJPEG2K jasper
    ++ lib.optional enableFfmpeg ffmpeg
    ++ lib.optionals (enableFfmpeg && stdenv.isDarwin)
                     [ VideoDecodeAcceleration bzip2 ]
    ++ lib.optionals enableGStreamer (with gst_all_1; [ gstreamer gst-plugins-base ])
    ++ lib.optional enableOvis ogre
    ++ lib.optional enableGPhoto2 libgphoto2
    ++ lib.optional enableDC1394 libdc1394
    ++ lib.optional enableEigen eigen
    ++ lib.optional enableOpenblas openblas
    # There is seemingly no compile-time flag for Tesseract.  It's
    # simply enabled automatically if contrib is built, and it detects
    # tesseract & leptonica.
    ++ lib.optionals enableTesseract [ tesseract leptonica ]
    ++ lib.optional enableTbb tbb
    ++ lib.optional enableCuda cudatoolkit
    ++ lib.optionals stdenv.isDarwin [ cf-private AVFoundation Cocoa QTKit VideoDecodeAcceleration bzip2 ]
    ++ lib.optionals enableDocs [ doxygen graphviz-nox ];

  propagatedBuildInputs = lib.optional enablePython pythonPackages.numpy;

  nativeBuildInputs = [ cmake pkgconfig unzip ];

  NIX_CFLAGS_COMPILE = lib.optional enableEXR "-I${ilmbase.dev}/include/OpenEXR";

  # Configure can't find the library without this.
  OpenBLAS_HOME = lib.optionalString enableOpenblas openblas;

  cmakeFlags = [
    "-DWITH_OPENMP=ON"
    "-DBUILD_PROTOBUF=${printEnabled (!useSystemProtobuf)}"
    "-DPROTOBUF_UPDATE_FILES=${printEnabled useSystemProtobuf}"
    "-DOPENCV_ENABLE_NONFREE=${printEnabled enableUnfree}"
    "-DBUILD_TESTS=OFF"
    "-DBUILD_PERF_TESTS=OFF"
    "-DBUILD_DOCS=${printEnabled enableDocs}"
    (opencvFlag "IPP" enableIpp)
    (opencvFlag "TIFF" enableTIFF)
    (opencvFlag "JASPER" enableJPEG2K)
    (opencvFlag "WEBP" enableWebP)
    (opencvFlag "JPEG" enableJPEG)
    (opencvFlag "PNG" enablePNG)
    (opencvFlag "OPENEXR" enableEXR)
    (opencvFlag "CUDA" enableCuda)
    (opencvFlag "CUBLAS" enableCuda)
    (opencvFlag "TBB" enableTbb)
  ] ++ lib.optionals enableCuda [
    "-DCUDA_FAST_MATH=ON"
    "-DCUDA_HOST_COMPILER=${cudatoolkit.cc}/bin/cc"
    "-DCUDA_NVCC_FLAGS=--expt-relaxed-constexpr"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DWITH_OPENCL=OFF"
    "-DWITH_LAPACK=OFF"
  ] ++ lib.optionals enablePython [
    "-DOPENCV_SKIP_PYTHON_LOADER=ON"
  ];

  enableParallelBuilding = true;

  postBuild = lib.optionalString enableDocs ''
    make doxygen
  '';

  # By default $out/lib/pkgconfig/opencv.pc looks something like this:
  #
  #   prefix=/nix/store/10pzq1a8fkh8q4sysj8n6mv0w0nl0miq-opencv-3.4.1
  #   exec_prefix=${prefix}
  #   libdir=${exec_prefix}//nix/store/10pzq1a8fkh8q4sysj8n6mv0w0nl0miq-opencv-3.4.1/lib
  #   ...
  #   Libs: -L${exec_prefix}//nix/store/10pzq1a8fkh8q4sysj8n6mv0w0nl0miq-opencv-3.4.1/lib ...
  #
  # Note that ${exec_prefix} is set to $out but that $out is also appended to
  # ${exec_prefix}. This causes linker errors in downstream packages so we strip
  # of $out after the ${exec_prefix} prefix:
  postInstall = ''
    sed -i "s|{exec_prefix}/$out|{exec_prefix}|" \
      "$out/lib/pkgconfig/opencv.pc"
  '';

  hardeningDisable = [ "bindnow" "relro" ];

  passthru = lib.optionalAttrs enablePython { pythonPath = []; };

  meta = with stdenv.lib; {
    description = "Open Computer Vision Library with more than 500 algorithms";
    homepage = https://opencv.org/;
    license = with licenses; if enableUnfree then unfree else bsd3;
    maintainers = with maintainers; [mdaiter basvandijk];
    platforms = with platforms; linux ++ darwin;
  };
}
