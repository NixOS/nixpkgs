{ config, stdenv, lib, fetchFromGitHub, cmake, gtest, doCheck ? true
, cudaSupport ? config.cudaSupport or false, ncclSupport ? false
, rLibrary ? false, cudaPackages, llvmPackages, R, rPackages }:

assert ncclSupport -> cudaSupport;
# Disable regular tests when building the R package
# because 1) the R package runs its own tests and
# 2) the R package creates a different binary shared
# object that isn't compatible with the regular CLI
# tests.
assert rLibrary -> doCheck != true;

stdenv.mkDerivation rec {
  pnameBase = "xgboost";
  # prefix with r when building the R library
  # The R package build results in a special xgboost.so file
  # that contains a subset of the .so file use for the CLI
  # and python version. In general, the CRAN version from
  # nixpkgs's r-modules should be used, but this non-standard
  # build allows for enabling CUDA and NCCL support which aren't
  # included in the CRAN release. Build with:
  # nix-build -E "with (import $NIXPKGS{}); \
  #   let \
  #     xgb = xgboost.override{rLibrary = true; doCheck = false;}; \
  #   in \
  #   rWrapper.override{ packages = [ xgb ]; }"
  pname = lib.optionalString rLibrary "r-" + pnameBase;
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "dmlc";
    repo = pnameBase;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-unTss2byytG8KUQfg5s34YpRuHHDLo7D/ZickHhz1AE=";
  };

  nativeBuildInputs = [ cmake ]
    ++ lib.optionals stdenv.isDarwin [ llvmPackages.openmp ]
    ++ lib.optionals cudaSupport [ cudaPackages.autoAddOpenGLRunpathHook ]
    ++ lib.optionals rLibrary [ R ];

  buildInputs = [ gtest ] ++ lib.optional cudaSupport cudaPackages.cudatoolkit
    ++ lib.optional ncclSupport cudaPackages.nccl;

  propagatedBuildInputs = lib.optionals rLibrary [
    rPackages.data_table
    rPackages.jsonlite
    rPackages.Matrix
  ];

  cmakeFlags = lib.optionals doCheck [ "-DGOOGLE_TEST=ON" ]
    ++ lib.optionals cudaSupport [
      "-DUSE_CUDA=ON"
      "-DCUDA_HOST_COMPILER=${cudaPackages.cudatoolkit.cc}/bin/cc"
    ] ++ lib.optionals (cudaSupport
      && lib.versionAtLeast cudaPackages.cudatoolkit.version "11.4.0")
    [ "-DBUILD_WITH_CUDA_CUB=ON" ]
    ++ lib.optionals ncclSupport [ "-DUSE_NCCL=ON" ]
    ++ lib.optionals rLibrary [ "-DR_LIB=ON" ];

  preConfigure = lib.optionals rLibrary ''
    substituteInPlace cmake/RPackageInstall.cmake.in --replace "CMD INSTALL" "CMD INSTALL -l $out/library"
    export R_LIBS_SITE="$R_LIBS_SITE''${R_LIBS_SITE:+:}$out/library"
  '';

  inherit doCheck;

  # By default, cmake build will run ctests with all checks enabled
  # If we're building with cuda, we run ctest manually so that we can skip the GPU tests
  checkPhase = lib.optionalString cudaSupport ''
    ctest --force-new-ctest-process ${
      lib.optionalString cudaSupport "-E TestXGBoostLib"
    }
  '';

  installPhase =
    let libname = "libxgboost${stdenv.hostPlatform.extensions.sharedLibrary}";
    in ''
      runHook preInstall
      mkdir -p $out
      cp -r ../include $out
      cp -r ../dmlc-core/include/dmlc $out/include
      cp -r ../rabit/include/rabit $out/include
    '' + lib.optionalString (!rLibrary) ''
      install -Dm755 ../lib/${libname} $out/lib/${libname}
      install -Dm755 ../xgboost $out/bin/xgboost
    ''
    # the R library option builds a completely different binary xgboost.so instead of
    # libxgboost.so, which isn't full featured for python and CLI
    + lib.optionalString rLibrary ''
      mkdir $out/library
      export R_LIBS_SITE="$out/library:$R_LIBS_SITE''${R_LIBS_SITE:+:}"
      make install -l $out/library
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
      "Scalable, Portable and Distributed Gradient Boosting (GBDT, GBRT or GBM) Library";
    homepage = "https://github.com/dmlc/xgboost";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar nviets ];
  };
}
