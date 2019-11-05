{ lib, stdenv
, fetchurl, fetchFromGitHub, fetchpatch
, cmake, pkgconfig, unzip, zlib, pcre, hdf5
, glog, boost, gflags, protobuf
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

, enableCuda      ? (config.cudaSupport or false) &&
                    stdenv.hostPlatform.isx86_64, cudatoolkit

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

, AVFoundation, Cocoa, VideoDecodeAcceleration, bzip2
}:

let
  version = "4.1.2";

  src = fetchFromGitHub {
    owner  = "opencv";
    repo   = "opencv";
    rev    = version;
    sha256 = "0c98ziwvfrzdzwn52a36d37n5rac8zmxq2jn479bzfaii1bib8xx";
  };

  contribSrc = fetchFromGitHub {
    owner  = "opencv";
    repo   = "opencv_contrib";
    rev    = version;
    sha256 = "10ryyxhggin5dk5glf4ycyrfryqf50f4bs10biv6nxlrrinm2di4";
  };

  # Contrib must be built in order to enable Tesseract support:
  buildContrib = enableContrib || enableTesseract || enableOvis;

  # See opencv/3rdparty/ippicv/ippicv.cmake
  ippicv = {
    src = fetchFromGitHub {
      owner  = "opencv";
      repo   = "opencv_3rdparty";
      rev    = "32e315a5b106a7b89dbed51c28f8120a48b368b4";
      sha256 = "19w9f0r16072s59diqxsr5q6nmwyz9gnxjs49nglzhd66p3ddbkp";
    } + "/ippicv";
    files = let name = platform : "ippicv_2019_${platform}_general_20180723.tgz"; in
      if stdenv.hostPlatform.system == "x86_64-linux" then
      { ${name "lnx_intel64"} = "c0bd78adb4156bbf552c1dfe90599607"; }
      else if stdenv.hostPlatform.system == "i686-linux" then
      { ${name "lnx_ia32"}    = "4f38432c30bfd6423164b7a24bbc98a0"; }
      else if stdenv.hostPlatform.system == "x86_64-darwin" then
      { ${name "mac_intel64"} = "fe6b2bb75ae0e3f19ad3ae1a31dfa4a2"; }
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

  # See opencv/modules/gapi/cmake/DownloadADE.cmake
  ade = rec {
    src = fetchurl {
      url = "https://github.com/opencv/ade/archive/${name}";
      sha256 = "04n9na2bph706bdxnnqfcbga4cyj8kd9s9ni7qyvnpj5v98jwvlm";
    };
    name = "v0.1.1f.zip";
    md5 = "b624b995ec9c439cbc2e9e6ee940d3a2";
    dst = ".cache/ade";
  };

  # See opencv/cmake/OpenCVDownload.cmake
  installExtraFiles = extra : with lib; ''
    mkdir -p "${extra.dst}"
  '' + concatStrings (flip mapAttrsToList extra.files (name : md5 : ''
    ln -s "${extra.src}/${name}" "${extra.dst}/${md5}-${name}"
  ''));
  installExtraFile = extra: ''
    mkdir -p "${extra.dst}"
    ln -s "${extra.src}" "${extra.dst}/${extra.md5}-${extra.name}"
  '';

  opencvFlag = name: enabled: "-DWITH_${name}=${printEnabled enabled}";

  printEnabled = enabled : if enabled then "ON" else "OFF";
in

stdenv.mkDerivation {
  pname = "opencv";
  inherit version src;

  postUnpack = lib.optionalString buildContrib ''
    cp --no-preserve=mode -r "${contribSrc}/modules" "$NIX_BUILD_TOP/source/opencv_contrib"
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
    installExtraFile ade +
    lib.optionalString enableIpp (installExtraFiles ippicv) + (
    lib.optionalString buildContrib ''
      cmakeFlagsArray+=("-DOPENCV_EXTRA_MODULES_PATH=$NIX_BUILD_TOP/source/opencv_contrib")

      ${installExtraFiles vgg}
      ${installExtraFiles boostdesc}
      ${installExtraFiles face}
    '');

  postConfigure = ''
    [ -e modules/core/version_string.inc ]
    echo '"(build info elided)"' > modules/core/version_string.inc
  '';

  buildInputs =
       [ zlib pcre hdf5 glog boost gflags protobuf ]
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
    ++ lib.optionals stdenv.isDarwin [ bzip2 AVFoundation Cocoa VideoDecodeAcceleration ]
    ++ lib.optionals enableDocs [ doxygen graphviz-nox ];

  propagatedBuildInputs = lib.optional enablePython pythonPackages.numpy;

  nativeBuildInputs = [ cmake pkgconfig unzip ];

  NIX_CFLAGS_COMPILE = lib.optional enableEXR "-I${ilmbase.dev}/include/OpenEXR";

  # Configure can't find the library without this.
  OpenBLAS_HOME = lib.optionalString enableOpenblas openblas;

  cmakeFlags = [
    "-DOPENCV_GENERATE_PKGCONFIG=ON"
    "-DWITH_OPENMP=ON"
    "-DBUILD_PROTOBUF=OFF"
    "-DPROTOBUF_UPDATE_FILES=ON"
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
    "-DBUILD_opencv_videoio=OFF"
  ] ++ lib.optionals enablePython [
    "-DOPENCV_SKIP_PYTHON_LOADER=ON"
  ];

  enableParallelBuilding = true;

  postBuild = lib.optionalString enableDocs ''
    make doxygen
  '';

  # By default $out/lib/pkgconfig/opencv4.pc looks something like this:
  #
  #   prefix=/nix/store/g0wnfyjjh4rikkvp22cpkh41naa43i4i-opencv-4.0.0
  #   exec_prefix=${prefix}
  #   libdir=${exec_prefix}//nix/store/g0wnfyjjh4rikkvp22cpkh41naa43i4i-opencv-4.0.0/lib
  #   includedir_old=${prefix}//nix/store/g0wnfyjjh4rikkvp22cpkh41naa43i4i-opencv-4.0.0/include/opencv4/opencv
  #   includedir_new=${prefix}//nix/store/g0wnfyjjh4rikkvp22cpkh41naa43i4i-opencv-4.0.0/include/opencv4
  #   ...
  #   Libs: -L${exec_prefix}//nix/store/g0wnfyjjh4rikkvp22cpkh41naa43i4i-opencv-4.0.0/lib ...
  # Note that ${exec_prefix} is set to $out but that $out is also appended to
  # ${exec_prefix}. This causes linker errors in downstream packages so we strip
  # of $out after the ${exec_prefix} and ${prefix} prefixes:
  postInstall = ''
    sed -i "s|{exec_prefix}/$out|{exec_prefix}|;s|{prefix}/$out|{prefix}|" \
      "$out/lib/pkgconfig/opencv4.pc"
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
