{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, cmake
, pkg-config
, unzip
, zlib
, pcre
, hdf5
, boost
, gflags
, protobuf
, config
, ocl-icd
, buildPackages

, enableJPEG ? true
, libjpeg
, enablePNG ? true
, libpng
, enableTIFF ? true
, libtiff
, enableWebP ? true
, libwebp
, enableEXR ? !stdenv.isDarwin
, openexr
, ilmbase
, enableJPEG2000 ? true
, openjpeg
, enableEigen ? true
, eigen
, enableOpenblas ? true
, openblas
, enableContrib ? true

, enableCuda ? (config.cudaSupport or false) && stdenv.hostPlatform.isx86_64
, cudatoolkit
, nvidia-optical-flow-sdk

, enableUnfree ? false
, enableIpp ? false
, enablePython ? false
, pythonPackages
, enableGtk2 ? false
, gtk2
, enableGtk3 ? false
, gtk3
, enableVtk ? false
, vtk
, enableFfmpeg ? true
, ffmpeg
, enableGStreamer ? true
, gst_all_1
, enableTesseract ? false
, tesseract
, leptonica
, enableTbb ? false
, tbb
, enableOvis ? false
, ogre
, enableGPhoto2 ? false
, libgphoto2
, enableDC1394 ? false
, libdc1394
, enableDocs ? false
, doxygen
, graphviz-nox

, AVFoundation
, Cocoa
, VideoDecodeAcceleration
, CoreMedia
, MediaToolbox
, bzip2
}:

let
  version = "4.5.4";

  src = fetchFromGitHub {
    owner = "opencv";
    repo = "opencv";
    rev = version;
    sha256 = "sha256-eIESkc/yYiZZ5iY4t/rAPd+jfjuMYR3srCBC4fO3g70=";
  };

  contribSrc = fetchFromGitHub {
    owner = "opencv";
    repo = "opencv_contrib";
    rev = version;
    sha256 = "sha256-RkCIGukZ8KJkmVZQAZTWdVcVKD2I3NcfGShcqzKhQD0=";
  };

  # Contrib must be built in order to enable Tesseract support:
  buildContrib = enableContrib || enableTesseract || enableOvis;

  # See opencv/3rdparty/ippicv/ippicv.cmake
  ippicv = {
    src = fetchFromGitHub {
      owner = "opencv";
      repo = "opencv_3rdparty";
      rev = "a56b6ac6f030c312b2dce17430eef13aed9af274";
      sha256 = "1msbkc3zixx61rcg6a04i1bcfhw1phgsrh93glq1n80hgsk3nbjq";
    } + "/ippicv";
    files = let name = platform: "ippicv_2019_${platform}_general_20180723.tgz"; in
      if stdenv.hostPlatform.system == "x86_64-linux" then
        { ${name "lnx_intel64"} = "c0bd78adb4156bbf552c1dfe90599607"; }
      else if stdenv.hostPlatform.system == "i686-linux" then
        { ${name "lnx_ia32"} = "4f38432c30bfd6423164b7a24bbc98a0"; }
      else if stdenv.hostPlatform.system == "x86_64-darwin" then
        { ${name "mac_intel64"} = "fe6b2bb75ae0e3f19ad3ae1a31dfa4a2"; }
      else
        throw "ICV is not available for this platform (or not yet supported by this package)";
    dst = ".cache/ippicv";
  };

  # See opencv_contrib/modules/xfeatures2d/cmake/download_vgg.cmake
  vgg = {
    src = fetchFromGitHub {
      owner = "opencv";
      repo = "opencv_3rdparty";
      rev = "fccf7cd6a4b12079f73bbfb21745f9babcd4eb1d";
      sha256 = "0r9fam8dplyqqsd3qgpnnfgf9l7lj44di19rxwbm8mxiw0rlcdvy";
    };
    files = {
      "vgg_generated_48.i" = "e8d0dcd54d1bcfdc29203d011a797179";
      "vgg_generated_64.i" = "7126a5d9a8884ebca5aea5d63d677225";
      "vgg_generated_80.i" = "7cd47228edec52b6d82f46511af325c5";
      "vgg_generated_120.i" = "151805e03568c9f490a5e3a872777b75";
    };
    dst = ".cache/xfeatures2d/vgg";
  };

  # See opencv_contrib/modules/xfeatures2d/cmake/download_boostdesc.cmake
  boostdesc = {
    src = fetchFromGitHub {
      owner = "opencv";
      repo = "opencv_3rdparty";
      rev = "34e4206aef44d50e6bbcd0ab06354b52e7466d26";
      sha256 = "13yig1xhvgghvxspxmdidss5lqiikpjr0ddm83jsi0k85j92sn62";
    };
    files = {
      "boostdesc_bgm.i" = "0ea90e7a8f3f7876d450e4149c97c74f";
      "boostdesc_bgm_bi.i" = "232c966b13651bd0e46a1497b0852191";
      "boostdesc_bgm_hd.i" = "324426a24fa56ad9c5b8e3e0b3e5303e";
      "boostdesc_binboost_064.i" = "202e1b3e9fec871b04da31f7f016679f";
      "boostdesc_binboost_128.i" = "98ea99d399965c03d555cef3ea502a0b";
      "boostdesc_binboost_256.i" = "e6dcfa9f647779eb1ce446a8d759b6ea";
      "boostdesc_lbgm.i" = "0ae0675534aa318d9668f2a179c2a052";
    };
    dst = ".cache/xfeatures2d/boostdesc";
  };

  # See opencv_contrib/modules/face/CMakeLists.txt
  face = {
    src = fetchFromGitHub {
      owner = "opencv";
      repo = "opencv_3rdparty";
      rev = "8afa57abc8229d611c4937165d20e2a2d9fc5a12";
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

  # See opencv/modules/wechat_qrcode/CMakeLists.txt
  wechat_qrcode = {
    src = fetchFromGitHub {
      owner = "opencv";
      repo = "opencv_3rdparty";
      rev = "a8b69ccc738421293254aec5ddb38bd523503252";
      sha256 = "sha256-/n6zHwf0Rdc4v9o4rmETzow/HTv+81DnHP+nL56XiTY=";
    };
    files = {
      "detect.caffemodel" = "238e2b2d6f3c18d6c3a30de0c31e23cf";
      "detect.prototxt" = "6fb4976b32695f9f5c6305c19f12537d";
      "sr.caffemodel" = "cbfcd60361a73beb8c583eea7e8e6664";
      "sr.prototxt" = "69db99927a70df953b471daaba03fbef";
    };
    dst = ".cache/wechat_qrcode";
  };

  # See opencv/cmake/OpenCVDownload.cmake
  installExtraFiles = extra: with lib; ''
    mkdir -p "${extra.dst}"
  '' + concatStrings (flip mapAttrsToList extra.files (name: md5: ''
    ln -s "${extra.src}/${name}" "${extra.dst}/${md5}-${name}"
  ''));
  installExtraFile = extra: ''
    mkdir -p "${extra.dst}"
    ln -s "${extra.src}" "${extra.dst}/${extra.md5}-${extra.name}"
  '';

  mkFlag = name: enabled: "-DWITH_${name}=${lib.boolToCMakeString enabled}";
in

stdenv.mkDerivation {
  pname = "opencv";
  inherit version src;

  postUnpack = lib.optionalString buildContrib ''
    cp --no-preserve=mode -r "${contribSrc}/modules" "$NIX_BUILD_TOP/source/opencv_contrib"
  '';

  # Ensures that we use the system OpenEXR rather than the vendored copy of the source included with OpenCV.
  patches = [
    ./cmake-don-t-use-OpenCVFindOpenEXR.patch
  ] ++ lib.optional enableCuda ./cuda_opt_flow.patch;

  # This prevents cmake from using libraries in impure paths (which
  # causes build failure on non NixOS)
  postPatch = ''
    sed -i '/Add these standard paths to the search paths for FIND_LIBRARY/,/^\s*$/{d}' CMakeLists.txt
  '';

  preConfigure =
    installExtraFile ade +
    lib.optionalString enableIpp (installExtraFiles ippicv) + (
      lib.optionalString buildContrib ''
        cmakeFlagsArray+=("-DOPENCV_EXTRA_MODULES_PATH=$NIX_BUILD_TOP/source/opencv_contrib")

        ${installExtraFiles vgg}
        ${installExtraFiles boostdesc}
        ${installExtraFiles face}
        ${installExtraFiles wechat_qrcode}
      ''
    );

  postConfigure = ''
    [ -e modules/core/version_string.inc ]
    echo '"(build info elided)"' > modules/core/version_string.inc
  '';

  buildInputs = [ zlib pcre boost gflags protobuf ]
    ++ lib.optional enablePython pythonPackages.python
    ++ lib.optional (stdenv.buildPlatform == stdenv.hostPlatform) hdf5
    ++ lib.optional enableGtk2 gtk2
    ++ lib.optional enableGtk3 gtk3
    ++ lib.optional enableVtk vtk
    ++ lib.optional enableJPEG libjpeg
    ++ lib.optional enablePNG libpng
    ++ lib.optional enableTIFF libtiff
    ++ lib.optional enableWebP libwebp
    ++ lib.optionals enableEXR [ openexr ilmbase ]
    ++ lib.optional enableJPEG2000 openjpeg
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
    ++ lib.optionals stdenv.isDarwin [ bzip2 AVFoundation Cocoa VideoDecodeAcceleration CoreMedia MediaToolbox ]
    ++ lib.optionals enableDocs [ doxygen graphviz-nox ];

  propagatedBuildInputs = lib.optional enablePython pythonPackages.numpy
    ++ lib.optionals enableCuda [ cudatoolkit nvidia-optical-flow-sdk ];

  nativeBuildInputs = [ cmake pkg-config unzip ]
  ++ lib.optionals enablePython [
    pythonPackages.pip
    pythonPackages.wheel
    pythonPackages.setuptools
  ];

  NIX_CFLAGS_COMPILE = lib.optionalString enableEXR "-I${ilmbase.dev}/include/OpenEXR";

  # Configure can't find the library without this.
  OpenBLAS_HOME = lib.optionalString enableOpenblas openblas;

  cmakeFlags = [
    "-DOPENCV_GENERATE_PKGCONFIG=ON"
    "-DWITH_OPENMP=ON"
    "-DBUILD_PROTOBUF=OFF"
    "-DProtobuf_PROTOC_EXECUTABLE=${lib.getExe buildPackages.protobuf}"
    "-DPROTOBUF_UPDATE_FILES=ON"
    "-DOPENCV_ENABLE_NONFREE=${lib.boolToCMakeString enableUnfree}"
    "-DBUILD_TESTS=OFF"
    "-DBUILD_PERF_TESTS=OFF"
    "-DBUILD_DOCS=${lib.boolToCMakeString enableDocs}"
    # "OpenCV disables pkg-config to avoid using of host libraries. Consider using PKG_CONFIG_LIBDIR to specify target SYSROOT"
    # but we have proper separation of build and host libs :), fixes cross
    "-DOPENCV_ENABLE_PKG_CONFIG=ON"
    (mkFlag "IPP" enableIpp)
    (mkFlag "TIFF" enableTIFF)
    (mkFlag "WEBP" enableWebP)
    (mkFlag "JPEG" enableJPEG)
    (mkFlag "PNG" enablePNG)
    (mkFlag "OPENEXR" enableEXR)
    (mkFlag "OPENJPEG" enableJPEG2000)
    "-DWITH_JASPER=OFF" # OpenCV falls back to a vendored copy of Jasper when OpenJPEG is disabled
    (mkFlag "CUDA" enableCuda)
    (mkFlag "CUBLAS" enableCuda)
    (mkFlag "TBB" enableTbb)
  ] ++ lib.optionals enableCuda [
    "-DCUDA_FAST_MATH=ON"
    "-DCUDA_HOST_COMPILER=${cudatoolkit.cc}/bin/cc"
    "-DCUDA_NVCC_FLAGS=--expt-relaxed-constexpr"
    "-DNVIDIA_OPTICAL_FLOW_2_0_HEADERS_PATH=${nvidia-optical-flow-sdk}"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DWITH_OPENCL=OFF"
    "-DWITH_LAPACK=OFF"
  ] ++ lib.optionals (!stdenv.isDarwin) [
    "-DOPENCL_LIBRARY=${ocl-icd}/lib/libOpenCL.so"
  ] ++ lib.optionals enablePython [
    "-DOPENCV_SKIP_PYTHON_LOADER=ON"
  ];

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
  ''
  # install python distribution information, so other packages can `import opencv`
  + lib.optionalString enablePython ''
    pushd $NIX_BUILD_TOP/$sourceRoot/modules/python/package
    python -m pip wheel --verbose --no-index --no-deps --no-clean --no-build-isolation --wheel-dir dist .

    pushd dist
    python -m pip install ./*.whl --no-index --no-warn-script-location --prefix="$out" --no-cache

    # the cv2/__init__.py just tries to check provide "nice user feedback" if the installation is bad
    # however, this also causes infinite recursion when used by other packages
    rm -r $out/${pythonPackages.python.sitePackages}/cv2

    popd
    popd
  '';

  passthru = lib.optionalAttrs enablePython { pythonPath = [ ]; };

  meta = with lib; {
    description = "Open Computer Vision Library with more than 500 algorithms";
    homepage = "https://opencv.org/";
    license = with licenses; if enableUnfree then unfree else bsd3;
    maintainers = with maintainers; [ mdaiter basvandijk ];
    platforms = with platforms; linux ++ darwin;
  };
}
