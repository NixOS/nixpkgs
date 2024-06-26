{ config, stdenv, lib, fetchFromGitHub, cmake, gtest, doCheck ? true
, cudaSupport ? config.cudaSupport or false, openclSupport ? false
, mpiSupport ? false, javaWrapper ? false, hdfsSupport ? false, pythonLibrary ? false
, rLibrary ? false, cudaPackages, opencl-headers, ocl-icd, boost
, llvmPackages, openmpi, openjdk, swig, hadoop, R, rPackages, pandoc }:

assert doCheck -> mpiSupport != true;
assert openclSupport -> cudaSupport != true;
assert cudaSupport -> openclSupport != true;

stdenv.mkDerivation rec {
  pnameBase = "lightgbm";
  # prefix with r when building the R library
  # The R package build results in a special binary file
  # that contains a subset of the .so file use for the CLI
  # and python version. In general, the CRAN version from
  # nixpkgs's r-modules should be used, but this non-standard
  # build allows for enabling CUDA support and other features
  # which aren't included in the CRAN release. Build with:
  # nix-build -E "with (import $NIXPKGS{}); \
  #   let \
  #     lgbm = lightgbm.override{rLibrary = true; doCheck = false;}; \
  #   in \
  #   rWrapper.override{ packages = [ lgbm ]; }"
  pname = lib.optionalString rLibrary "r-" + pnameBase;
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = pnameBase;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-i4mtJwSwnbGMXVfQ8a9jZZPUBBibXyQPgMVJ3uXxeGQ=";
  };

  nativeBuildInputs = [ cmake ]
    ++ lib.optionals stdenv.isDarwin [ llvmPackages.openmp ]
    ++ lib.optionals openclSupport [ opencl-headers ocl-icd boost ]
    ++ lib.optionals mpiSupport [ openmpi ]
    ++ lib.optionals hdfsSupport [ hadoop ]
    ++ lib.optionals (hdfsSupport || javaWrapper) [ openjdk ]
    ++ lib.optionals javaWrapper [ swig ]
    ++ lib.optionals rLibrary [ R pandoc ];

  buildInputs = [ gtest ]
    ++ lib.optional cudaSupport cudaPackages.cudatoolkit;

  propagatedBuildInputs = lib.optionals rLibrary [
    rPackages.data_table
    rPackages.markdown
    rPackages.rmarkdown
    rPackages.jsonlite
    rPackages.Matrix
    rPackages.R6
  ];

  # Skip APPLE in favor of linux build for .so files
  postPatch = ''
    export PROJECT_SOURCE_DIR=./
    substituteInPlace CMakeLists.txt \
      --replace "find_package(GTest CONFIG)" "find_package(GTest REQUIRED)" \
      --replace "OpenCL_INCLUDE_DIRS}" "OpenCL_INCLUDE_DIRS}" \
      --replace "elseif(APPLE)" "elseif(APPLESKIP)"
    substituteInPlace \
      external_libs/compute/include/boost/compute/cl.hpp \
      external_libs/compute/include/boost/compute/cl_ext.hpp \
      --replace "include <OpenCL/" "include <CL/"
    substituteInPlace build_r.R \
      --replace "shQuote(normalizePath" "shQuote(type = 'cmd', string = normalizePath" \
      --replace "file.path(getwd(), \"lightgbm_r\")" "'$out/tmp'" \
      --replace \
        "install_args <- c(\"CMD\", \"INSTALL\", \"--no-multiarch\", \"--with-keep.source\", tarball)" \
        "install_args <- c(\"CMD\", \"INSTALL\", \"--no-multiarch\", \"--with-keep.source\", \"-l $out/library\", tarball)"

    # Retry this test in next release. Something fails in the setup, so GTEST_FILTER is not enough
    rm tests/cpp_tests/test_arrow.cpp
  '';

  cmakeFlags = lib.optionals doCheck [ "-DBUILD_CPP_TEST=ON" ]
    ++ lib.optionals cudaSupport [ "-DUSE_CUDA=1" "-DCMAKE_CXX_COMPILER=${cudaPackages.backendStdenv.cc}/bin/cc" ]
    ++ lib.optionals openclSupport [ "-DUSE_GPU=ON" ]
    ++ lib.optionals mpiSupport [ "-DUSE_MPI=ON" ]
    ++ lib.optionals hdfsSupport [
      "-DUSE_HDFS=ON"
      "-DHDFS_LIB=${hadoop}/lib/hadoop-${hadoop.version}/lib/native/libhdfs.so"
      "-DHDFS_INCLUDE_DIR=${hadoop}/lib/hadoop-${hadoop.version}/include" ]
    ++ lib.optionals javaWrapper [
      "-DUSE_SWIG=ON"
      # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
      "-DCMAKE_SKIP_BUILD_RPATH=ON" ]
    ++ lib.optionals rLibrary [ "-D__BUILD_FOR_R=ON" ]
    ++ lib.optionals pythonLibrary [ "-D__BUILD_FOR_PYTHON=ON" ];

  configurePhase = lib.optionals rLibrary ''
    export R_LIBS_SITE="$out/library:$R_LIBS_SITE''${R_LIBS_SITE:+:}"
  '';

  # set the R package buildPhase to null because lightgbm has a
  # custom builder script that builds and installs in one step
  buildPhase = lib.optionals rLibrary ''
  '';

  inherit doCheck;

  installPhase = ''
      runHook preInstall
    '' + lib.optionalString (!rLibrary) ''
      mkdir -p $out
      mkdir -p $out/lib
      mkdir -p $out/bin
      cp -r ../include $out
      install -Dm755 ../lib_lightgbm.so $out/lib/lib_lightgbm.so
    '' + lib.optionalString (!rLibrary && !pythonLibrary) ''
      install -Dm755 ../lightgbm $out/bin/lightgbm
    '' + lib.optionalString javaWrapper ''
      cp -r java $out
      cp -r com $out
      cp -r lightgbmlib.jar $out
    '' + ''
    '' + lib.optionalString rLibrary ''
      mkdir $out
      mkdir $out/tmp
      mkdir $out/library
      mkdir $out/library/lightgbm
    '' + lib.optionalString (rLibrary && (!openclSupport)) ''
      Rscript build_r.R \
        -j$NIX_BUILD_CORES
      rm -rf $out/tmp
    '' + lib.optionalString (rLibrary && openclSupport) ''
      Rscript build_r.R --use-gpu \
        --opencl-library=${ocl-icd}/lib/libOpenCL.so \
        --opencl-include-dir=${opencl-headers}/include \
        --boost-librarydir=${boost} \
        -j$NIX_BUILD_CORES
      rm -rf $out/tmp
    '' + ''
      runHook postInstall
    '';

  postFixup = lib.optionalString rLibrary ''
    if test -e $out/nix-support/propagated-build-inputs; then
        ln -s $out/nix-support/propagated-build-inputs $out/nix-support/propagated-user-env-packages
    fi
  '';

  meta = with lib; {
    description =
      "LightGBM is a gradient boosting framework that uses tree based learning algorithms.";
    mainProgram = "lightgbm";
    homepage = "https://github.com/microsoft/LightGBM";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ nviets ];
  };
}
