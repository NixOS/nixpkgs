{
  config,
  stdenv,
  lib,
  fetchFromGitHub,
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
  stdenv = throw "Use effectiveStdenv instead of stdenv in xgboost derivation.";
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
  pname = lib.optionalString rLibrary "r-" + "xgboost";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "dmlc";
    repo = "xgboost";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-khaD9gvKfUyWhkrIZXzGzKw/nfgeTcp9akCi5X3IORo=";
  };

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals effectiveStdenv.hostPlatform.isDarwin [ llvmPackages.openmp ]
  ++ lib.optionals cudaSupport [ autoAddDriverRunpath ]
  ++ lib.optionals rLibrary [ R ];

  buildInputs = [
    gtest
  ]
  ++ lib.optional cudaSupport cudaPackages.cudatoolkit
  ++ lib.optional cudaSupport cudaPackages.cuda_cudart
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

  # on Darwin, cmake uses find_library to locate R instead of using the PATH
  env.NIX_LDFLAGS = "-L${R}/lib/R/lib";

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
      xsimdTests = lib.optionals effectiveStdenv.hostPlatform.isDarwin [
        "ThreadGroup.TimerThread"
        "ThreadGroup.TimerThreadSimple"
      ];
      networkingTest = [
        "AllgatherTest.Basic"
        "AllgatherTest.VAlgo"
        "AllgatherTest.VBasic"
        "AllgatherTest.VRing"
        "AllreduceGlobal.Basic"
        "AllreduceGlobal.Small"
        "AllreduceTest.Basic"
        "AllreduceTest.BitOr"
        "AllreduceTest.Restricted"
        "AllreduceTest.Sum"
        "Approx.PartitionerColumnSplit"
        "BroadcastTest.Basic"
        "CPUHistogram.BuildHistColSplit"
        "CPUHistogram.BuildHistColumnSplit"
        "CPUPredictor.CategoricalPredictLeafColumnSplit"
        "CPUPredictor.CategoricalPredictionColumnSplit"
        "ColumnSplit/ColumnSplitTrainingTest*"
        "ColumnSplit/TestApproxColumnSplit*"
        "ColumnSplit/TestHistColumnSplit*"
        "ColumnSplitObjective/TestColumnSplit*"
        "Cpu/ColumnSplitTrainingTest*"
        "CommGroupTest.Basic"
        "CommTest.Channel"
        "CpuPredictor.BasicColumnSplit"
        "CpuPredictor.IterationRangeColmnSplit"
        "CpuPredictor.LesserFeaturesColumnSplit"
        "CpuPredictor.SparseColumnSplit"
        "DistributedMetric/TestDistributedMetric.BinaryAUCRowSplit/Dist_*"
        "InitEstimation.FitStumpColumnSplit"
        "MetaInfo.GetSetFeatureColumnSplit"
        "Quantile.ColumnSplit"
        "Quantile.ColumnSplitBasic"
        "Quantile.ColumnSplitSorted"
        "Quantile.ColumnSplitSortedBasic"
        "Quantile.Distributed"
        "Quantile.DistributedBasic"
        "Quantile.SameOnAllWorkers"
        "Quantile.SortedDistributed"
        "Quantile.SortedDistributedBasic"
        "QuantileHist.MultiPartitionerColumnSplit"
        "QuantileHist.PartitionerColumnSplit"
        "Stats.SampleMean"
        "Stats.WeightedSampleMean"
        "SimpleDMatrix.ColumnSplit"
        "TrackerAPITest.CAPI"
        "TrackerTest.AfterShutdown"
        "TrackerTest.Bootstrap"
        "TrackerTest.GetHostAddress"
        "TrackerTest.Print"
        "VectorAllgatherV.Basic"
      ];
      excludedTests = xsimdTests ++ networkingTest;
    in
    "-${builtins.concatStringsSep ":" excludedTests}";

  installPhase = ''
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
    license = licenses.asl20;
    mainProgram = "xgboost";
    platforms = platforms.unix;
    maintainers = with maintainers; [
      nviets
    ];
  };
}
