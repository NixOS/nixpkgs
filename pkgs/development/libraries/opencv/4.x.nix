{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, cmake
, pkg-config
, unzip
, zlib
, pcre2
, hdf5
, boost
, glib
, gflags
, protobuf_21
, config
, ocl-icd
, buildPackages
, qimgv
, opencv4

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
, enableBlas ? true
, blas
, enableVA ? !stdenv.isDarwin
, libva
, enableContrib ? true

, enableCuda ? config.cudaSupport
, enableCublas ? enableCuda
, enableCudnn ? false # NOTE: CUDNN has a large impact on closure size so we disable it by default
, enableCufft ? enableCuda
, cudaPackages ? {}
, nvidia-optical-flow-sdk

, enableLto ? true
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
, elfutils
, gst_all_1
, orc
, libunwind
, zstd
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

, runAccuracyTests ? true
, runPerformanceTests ? false
# Modules to enable via BUILD_LIST to build a customized opencv.
# An empty lists means this setting is ommited which matches upstreams default.
, enabledModules ? [ ]

, AVFoundation
, Cocoa
, VideoDecodeAcceleration
, CoreMedia
, MediaToolbox
, Accelerate
, bzip2
, callPackage
}@inputs:

let
  version = "4.9.0";

  # It's necessary to consistently use backendStdenv when building with CUDA
  # support, otherwise we get libstdc++ errors downstream
  stdenv = throw "Use effectiveStdenv instead";
  effectiveStdenv = if enableCuda then cudaPackages.backendStdenv else inputs.stdenv;

  src = fetchFromGitHub {
    owner = "opencv";
    repo = "opencv";
    rev = version;
    hash = "sha256-3qqu4xlRyMbPKHHTIT+iRRGtpFlcv0NU8GNZpgjdi6k=";
  };

  contribSrc = fetchFromGitHub {
    owner = "opencv";
    repo = "opencv_contrib";
    rev = version;
    hash = "sha256-K74Ghk4uDqj4OWEzDxT2R3ERi+jkAWZszzezRenfuZ8=";
  };

  testDataSrc = fetchFromGitHub {
    owner = "opencv";
    repo = "opencv_extra";
    rev = version;
    hash = "sha256-pActKi7aN5EOZq2Fpf5mALnZq71c037/R3Q6wJ4uCfQ=";
  };

  # Contrib must be built in order to enable Tesseract support:
  buildContrib = enableContrib || enableTesseract || enableOvis;

  # See opencv/3rdparty/ippicv/ippicv.cmake
  ippicv = {
    src = fetchFromGitHub {
      owner = "opencv";
      repo = "opencv_3rdparty";
      rev = "0cc4aa06bf2bef4b05d237c69a5a96b9cd0cb85a";
      hash = "sha256-/kHivOgCkY9YdcRRaVgytXal3ChE9xFfGAB0CfFO5ec=";
    } + "/ippicv";
    files = let name = platform: "ippicv_2021.10.0_${platform}_20230919_general.tgz"; in
      if effectiveStdenv.hostPlatform.system == "x86_64-linux" then
        { ${name "lnx_intel64"} = "606a19b207ebedfe42d59fd916cc4850"; }
      else if effectiveStdenv.hostPlatform.system == "i686-linux" then
        { ${name "lnx_ia32"} = "ea08487b810baad2f68aca87b74a2db9"; }
      else if effectiveStdenv.hostPlatform.system == "x86_64-darwin" then
        { ${name "mac_intel64"} = "14f01c5a4780bfae9dde9b0aaf5e56fc"; }
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
      hash = "sha256-fjdGM+CxV1QX7zmF2AiR9NDknrP2PjyaxtjT21BVLmU=";
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
      hash = "sha256-m9yF4kfmpRJybohdRwUTmboeU+SbZQ6F6gm32PDWNBg=";
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
      hash = "sha256-WG/GudVpkO10kOJhoKXFMj672kggvyRYCIpezal3wcE=";
    };
    name = "v0.1.2d.zip";
    md5 = "dbb095a8bf3008e91edbbf45d8d34885";
    dst = ".cache/ade";
  };

  # See opencv_contrib/modules/wechat_qrcode/CMakeLists.txt
  wechat_qrcode = {
    src = fetchFromGitHub {
      owner = "opencv";
      repo = "opencv_3rdparty";
      rev = "a8b69ccc738421293254aec5ddb38bd523503252";
      hash = "sha256-/n6zHwf0Rdc4v9o4rmETzow/HTv+81DnHP+nL56XiTY=";
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
  installExtraFiles = extra: ''
    mkdir -p "${extra.dst}"
  '' + lib.concatStrings (lib.flip lib.mapAttrsToList extra.files (name: md5: ''
    ln -s "${extra.src}/${name}" "${extra.dst}/${md5}-${name}"
  ''));
  installExtraFile = extra: ''
    mkdir -p "${extra.dst}"
    ln -s "${extra.src}" "${extra.dst}/${extra.md5}-${extra.name}"
  '';

  opencvFlag = name: enabled: "-DWITH_${name}=${printEnabled enabled}";

  printEnabled = enabled: if enabled then "ON" else "OFF";
  withOpenblas = (enableBlas && blas.provider.pname == "openblas");
  #multithreaded openblas conflicts with opencv multithreading, which manifest itself in hung tests
  #https://github.com/OpenMathLib/OpenBLAS/wiki/Faq/4bded95e8dc8aadc70ce65267d1093ca7bdefc4c#multi-threaded
  openblas_ = blas.provider.override { singleThreaded = true; };

  inherit (cudaPackages) cudaFlags cudaVersion;
  inherit (cudaFlags) cudaCapabilities;

in

effectiveStdenv.mkDerivation {
  pname = "opencv";
  inherit version src;

  outputs = [
    "out"
    "cxxdev"
  ] ++ lib.optionals (runAccuracyTests || runPerformanceTests) [
    "package_tests"
  ];
  cudaPropagateToOutput = "cxxdev";

  postUnpack = lib.optionalString buildContrib ''
    cp --no-preserve=mode -r "${contribSrc}/modules" "$NIX_BUILD_TOP/source/opencv_contrib"
  '';

  # Ensures that we use the system OpenEXR rather than the vendored copy of the source included with OpenCV.
  patches = [
    ./cmake-don-t-use-OpenCVFindOpenEXR.patch
  ] ++ lib.optionals enableContrib [
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

  buildInputs = [
    boost
    gflags
    glib
    pcre2
    protobuf_21
    zlib
  ] ++ lib.optionals enablePython [
    pythonPackages.python
  ] ++ lib.optionals (effectiveStdenv.buildPlatform == effectiveStdenv.hostPlatform) [
    hdf5
  ] ++ lib.optionals enableGtk2 [
    gtk2
  ] ++ lib.optionals enableGtk3 [
    gtk3
  ] ++ lib.optionals enableVtk [
    vtk
  ] ++ lib.optionals enableJPEG [
    libjpeg
  ] ++ lib.optionals enablePNG [
    libpng
  ] ++ lib.optionals enableTIFF [
    libtiff
  ] ++ lib.optionals enableWebP [
    libwebp
  ] ++ lib.optionals enableEXR [
    openexr
    ilmbase
  ] ++ lib.optionals enableJPEG2000 [
    openjpeg
  ] ++ lib.optionals enableFfmpeg [
    ffmpeg
  ] ++ lib.optionals (enableFfmpeg && effectiveStdenv.isDarwin) [
    bzip2
    VideoDecodeAcceleration
  ] ++ lib.optionals (enableGStreamer && effectiveStdenv.isLinux) [
    elfutils
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
    libunwind
    orc
    zstd
  ] ++ lib.optionals enableOvis [
    ogre
  ] ++ lib.optionals enableGPhoto2 [
    libgphoto2
  ] ++ lib.optionals enableDC1394 [
    libdc1394
  ] ++ lib.optionals enableEigen [
    eigen
  ] ++ lib.optionals enableVA [
    libva
  ] ++ lib.optionals enableBlas [
    blas.provider
  ] ++ lib.optionals enableTesseract [
    # There is seemingly no compile-time flag for Tesseract.  It's
    # simply enabled automatically if contrib is built, and it detects
    # tesseract & leptonica.
    tesseract
    leptonica
  ] ++ lib.optionals enableTbb [
    tbb
  ] ++ lib.optionals effectiveStdenv.isDarwin [
    bzip2
    AVFoundation
    Cocoa
    VideoDecodeAcceleration
    CoreMedia
    MediaToolbox
    Accelerate
  ] ++ lib.optionals enableDocs [
    doxygen
    graphviz-nox
  ] ++ lib.optionals enableCuda [
    cudaPackages.cuda_cudart
    cudaPackages.cuda_cccl # <thrust/*>
    cudaPackages.libnpp # npp.h
    cudaPackages.nvidia-optical-flow-sdk
  ] ++ lib.optionals enableCublas [
    # May start using the default $out instead once
    # https://github.com/NixOS/nixpkgs/issues/271792
    # has been addressed
    cudaPackages.libcublas # cublas_v2.h
  ] ++ lib.optionals enableCudnn [
    cudaPackages.cudnn # cudnn.h
  ] ++ lib.optionals enableCufft [
    cudaPackages.libcufft # cufft.h
  ];

  propagatedBuildInputs = lib.optionals enablePython [ pythonPackages.numpy ];

  nativeBuildInputs = [ cmake pkg-config unzip ]
  ++ lib.optionals enablePython [
    pythonPackages.pip
    pythonPackages.wheel
    pythonPackages.setuptools
  ] ++ lib.optionals enableCuda [
    cudaPackages.cuda_nvcc
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString enableEXR "-I${ilmbase.dev}/include/OpenEXR";

  # Configure can't find the library without this.
  OpenBLAS_HOME = lib.optionalString withOpenblas openblas_.dev;
  OpenBLAS = lib.optionalString withOpenblas openblas_;

  cmakeFlags = [
    "-DOPENCV_GENERATE_PKGCONFIG=ON"
    "-DWITH_OPENMP=ON"
    "-DBUILD_PROTOBUF=OFF"
    "-DProtobuf_PROTOC_EXECUTABLE=${lib.getExe buildPackages.protobuf_21}"
    "-DPROTOBUF_UPDATE_FILES=ON"
    "-DOPENCV_ENABLE_NONFREE=${printEnabled enableUnfree}"
    "-DBUILD_TESTS=${printEnabled runAccuracyTests}"
    "-DBUILD_PERF_TESTS=${printEnabled runPerformanceTests}"
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DBUILD_DOCS=${printEnabled enableDocs}"
    # "OpenCV disables pkg-config to avoid using of host libraries. Consider using PKG_CONFIG_LIBDIR to specify target SYSROOT"
    # but we have proper separation of build and host libs :), fixes cross
    "-DOPENCV_ENABLE_PKG_CONFIG=ON"
    (opencvFlag "IPP" enableIpp)
    (opencvFlag "TIFF" enableTIFF)
    (opencvFlag "WEBP" enableWebP)
    (opencvFlag "JPEG" enableJPEG)
    (opencvFlag "PNG" enablePNG)
    (opencvFlag "OPENEXR" enableEXR)
    (opencvFlag "OPENJPEG" enableJPEG2000)
    "-DWITH_JASPER=OFF" # OpenCV falls back to a vendored copy of Jasper when OpenJPEG is disabled
    (opencvFlag "TBB" enableTbb)

    # CUDA options
    (opencvFlag "CUDA" enableCuda)
    (opencvFlag "CUDA_FAST_MATH" enableCuda)
    (opencvFlag "CUBLAS" enableCublas)
    (opencvFlag "CUDNN" enableCudnn)
    (opencvFlag "CUFFT" enableCufft)

    # LTO options
    (opencvFlag "ENABLE_LTO" enableLto)
    (opencvFlag "ENABLE_THIN_LTO" (
      enableLto && (
        # Only clang supports thin LTO, so we must either be using clang through the effectiveStdenv,
        effectiveStdenv.cc.isClang ||
          # or through the backend effectiveStdenv.
          (enableCuda && effectiveStdenv.cc.isClang)
      )
    ))
  ] ++ lib.optionals enableCuda [
    "-DCUDA_FAST_MATH=ON"
    "-DCUDA_NVCC_FLAGS=--expt-relaxed-constexpr"

    # OpenCV respects at least three variables:
    # -DCUDA_GENERATION takes a single arch name, e.g. Volta
    # -DCUDA_ARCH_BIN takes a semi-colon separated list of real arches, e.g. "8.0;8.6"
    # -DCUDA_ARCH_PTX takes the virtual arch, e.g. "8.6"
    "-DCUDA_ARCH_BIN=${lib.concatStringsSep ";" cudaCapabilities}"
    "-DCUDA_ARCH_PTX=${lib.last cudaCapabilities}"

    "-DNVIDIA_OPTICAL_FLOW_2_0_HEADERS_PATH=${nvidia-optical-flow-sdk}"
  ] ++ lib.optionals effectiveStdenv.isDarwin [
    "-DWITH_OPENCL=OFF"
    "-DWITH_LAPACK=OFF"

    # Disable unnecessary vendoring that's enabled by default only for Darwin.
    # Note that the opencvFlag feature flags listed above still take
    # precedence, so we can safely list everything here.
    "-DBUILD_ZLIB=OFF"
    "-DBUILD_TIFF=OFF"
    "-DBUILD_OPENJPEG=OFF"
    "-DBUILD_JASPER=OFF"
    "-DBUILD_JPEG=OFF"
    "-DBUILD_PNG=OFF"
    "-DBUILD_WEBP=OFF"
  ] ++ lib.optionals (!effectiveStdenv.isDarwin) [
    "-DOPENCL_LIBRARY=${ocl-icd}/lib/libOpenCL.so"
  ] ++ lib.optionals enablePython [
    "-DOPENCV_SKIP_PYTHON_LOADER=ON"
  ] ++ lib.optionals (enabledModules != [ ]) [
    "-DBUILD_LIST=${lib.concatStringsSep "," enabledModules}"
  ];

  postBuild = lib.optionalString enableDocs ''
    make doxygen
  '';

  preInstall =
    lib.optionalString (runAccuracyTests || runPerformanceTests) ''
    mkdir $package_tests
    cp -R $src/samples $package_tests/
    ''
    + lib.optionalString runAccuracyTests "mv ./bin/*test* $package_tests/ \n"
    + lib.optionalString runPerformanceTests "mv ./bin/*perf* $package_tests/";

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
    mkdir "$cxxdev"
  ''
  # fix deps not progagating from opencv4.cxxdev if cuda is disabled
  # see https://github.com/NixOS/nixpkgs/issues/276691
  + lib.optionalString (!enableCuda) ''
    mkdir -p "$cxxdev/nix-support"
    echo "''${!outputDev}" >> "$cxxdev/nix-support/propagated-build-inputs"
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

  passthru = {
    cudaSupport = enableCuda;

    tests = {
      inherit (gst_all_1) gst-plugins-bad;
    }
    // lib.optionalAttrs (!effectiveStdenv.isDarwin) { inherit qimgv; }
    // lib.optionalAttrs (!enablePython) { pythonEnabled = pythonPackages.opencv4; }
    // lib.optionalAttrs (effectiveStdenv.buildPlatform != "x86_64-darwin") {
      opencv4-tests = callPackage ./tests.nix {
        inherit enableGStreamer enableGtk2 enableGtk3 runAccuracyTests runPerformanceTests testDataSrc;
        inherit opencv4;
      };
    }
    // lib.optionalAttrs (enableCuda) {
      no-libstdcxx-errors = callPackage ./libstdcxx-test.nix { attrName = "opencv4"; };
    };
  } // lib.optionalAttrs enablePython { pythonPath = [ ]; };

  meta = {
    description = "Open Computer Vision Library with more than 500 algorithms";
    homepage = "https://opencv.org/";
    license = if enableUnfree then lib.licenses.unfree else lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ basvandijk ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
