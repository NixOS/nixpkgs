{
  config,
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  gtest,
  doCheck ? true,
  autoAddDriverRunpath,
  cudaSupport ? config.cudaSupport,
  ncclSupport ? false,
  rLibrary ? false,
  cudaPackages,
  llvmPackages,
  R,
  rPackages,
}@inputs:

assert ncclSupport -> (cudaSupport && !cudaPackages.nccl.meta.unsupported);
# Disable regular tests when building the R package
# because 1) the R package runs its own tests and
# 2) the R package creates a different binary shared
# object that isn't compatible with the regular CLI
# tests.
assert rLibrary -> !doCheck;

let
  # This ensures xgboost gets the correct libstdc++ when
  # built with cuda support. This may be removed once
  # #226165 rewrites cudaStdenv
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else inputs.stdenv;
  # Ensures we don't use the stdenv value by accident.
  stdenv = builtins.throw "Use effectiveStdenv instead of stdenv in xgboost derivation.";
in

effectiveStdenv.mkDerivation rec {
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
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "dmlc";
    repo = pnameBase;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-LWco3A6zwdnAf8blU4qjW7PFEeZaTcJlVTwVrs7nwWM=";
  };

  patches = lib.optionals (cudaSupport && cudaPackages.cudaMajorMinorVersion == "12.4") [
    (fetchpatch {
      # https://github.com/dmlc/xgboost/pull/10123
      name = "Fix compilation with the ctk 12.4.";
      url = "https://github.com/dmlc/xgboost/commit/c760f85db0bc7bd6379901fbfb67ceccc2b37700.patch";
      hash = "sha256-iP9mll9pg8T2ztCR7dBPnLP17/x3ImJFrr5G3e2dqHo=";
    })
  ];

  nativeBuildInputs =
    [ cmake ]
    ++ lib.optionals effectiveStdenv.hostPlatform.isDarwin [ llvmPackages.openmp ]
    ++ lib.optionals cudaSupport [ autoAddDriverRunpath ]
    ++ lib.optionals rLibrary [ R ];

  buildInputs =
    [ gtest ]
    ++ lib.optional cudaSupport cudaPackages.cudatoolkit
    ++ lib.optional ncclSupport cudaPackages.nccl;

  propagatedBuildInputs = lib.optionals rLibrary [
    rPackages.data_table
    rPackages.jsonlite
    rPackages.Matrix
  ];

  cmakeFlags =
    lib.optionals doCheck [ "-DGOOGLE_TEST=ON" ]
    ++ lib.optionals cudaSupport [
      "-DUSE_CUDA=ON"
      # Their CMakeLists.txt does not respect CUDA_HOST_COMPILER, instead using the CXX compiler.
      # https://github.com/dmlc/xgboost/blob/ccf43d4ba0a94e2f0a3cc5a526197539ae46f410/CMakeLists.txt#L145
      "-DCMAKE_C_COMPILER=${effectiveStdenv.cc}/bin/gcc"
      "-DCMAKE_CXX_COMPILER=${effectiveStdenv.cc}/bin/g++"
    ]
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
    ctest --force-new-ctest-process ${lib.optionalString cudaSupport "-E TestXGBoostLib"}
  '';

  # Disable finicky tests from dmlc core that fail in Hydra. XGboost team
  # confirmed xgboost itself does not use this part of the dmlc code.
  GTEST_FILTER =
    let
      # Upstream Issue: https://github.com/xtensor-stack/xsimd/issues/456
      filteredTests = lib.optionals effectiveStdenv.hostPlatform.isDarwin [
        "ThreadGroup.TimerThread"
        "ThreadGroup.TimerThreadSimple"
      ];
    in
    "-${builtins.concatStringsSep ":" filteredTests}";

  installPhase =
    ''
      runHook preInstall
    ''
    # the R library option builds a completely different binary xgboost.so instead of
    # libxgboost.so, which isn't full featured for python and CLI
    + lib.optionalString rLibrary ''
      mkdir -p $out/library
      export R_LIBS_SITE="$out/library:$R_LIBS_SITE''${R_LIBS_SITE:+:}"
    ''
    + ''
      cmake --install .
      cp -r ../rabit/include/rabit $out/include
      runHook postInstall
    '';

  postFixup = lib.optionalString rLibrary ''
    if test -e $out/nix-support/propagated-build-inputs; then
        ln -s $out/nix-support/propagated-build-inputs $out/nix-support/propagated-user-env-packages
    fi
  '';

  meta = with lib; {
    description = "Scalable, Portable and Distributed Gradient Boosting (GBDT, GBRT or GBM) Library";
    homepage = "https://github.com/dmlc/xgboost";
    broken = cudaSupport && cudaPackages.cudaOlder "11.4";
    license = licenses.asl20;
    mainProgram = "xgboost";
    platforms = platforms.unix;
    maintainers = with maintainers; [
      abbradar
      nviets
    ];
  };
}
