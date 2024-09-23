{
  lib,
  config,
  fetchFromGitHub,
  stdenv,
  cmake,
  cudaPackages ? { },
  cudaSupport ? config.cudaSupport,
  pythonSupport ? true,
  pythonPackages,
  llvmPackages,
  blas,
  swig,
  autoAddDriverRunpath,
  optLevel ?
    let
      optLevels =
        lib.optionals stdenv.hostPlatform.avx2Support [ "avx2" ]
        ++ lib.optionals stdenv.hostPlatform.sse4_1Support [ "sse4" ]
        ++ [ "generic" ];
    in
    # Choose the maximum available optimization level
    builtins.head optLevels,
  faiss, # To run demos in the tests
  runCommand,
}@inputs:

let
  pname = "faiss";
  version = "1.8.0";

  inherit (cudaPackages) flags backendStdenv;

  stdenv = if cudaSupport then backendStdenv else inputs.stdenv;

  cudaComponents = with cudaPackages; [
    cuda_cudart # cuda_runtime.h
    libcublas
    libcurand
    cuda_cccl

    # cuda_profiler_api.h
    (cudaPackages.cuda_profiler_api or cudaPackages.cuda_nvprof)
  ];
in
stdenv.mkDerivation {
  inherit pname version;

  outputs = [
    "out"
    "demos"
  ] ++ lib.optionals pythonSupport [ "dist" ];

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nS8nhkNGGb2oAJKfr/MIAZjAwMxBGbNd16/CkEtv67I=";
  };

  # Remove the following substituteInPlace when updating
  # to a release that contains change from PR
  # https://github.com/facebookresearch/faiss/issues/3239
  # that fixes building faiss with swig 4.2.x
  postPatch = ''
    substituteInPlace faiss/python/swigfaiss.swig \
      --replace-fail '#ifdef SWIGWORDSIZE64' '#if (__SIZEOF_LONG__ == 8)'
  '';

  nativeBuildInputs =
    [ cmake ]
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_nvcc
      autoAddDriverRunpath
    ]
    ++ lib.optionals pythonSupport [
      pythonPackages.python
      pythonPackages.setuptools
      pythonPackages.pip
      pythonPackages.wheel
    ];

  buildInputs =
    [
      blas
      swig
    ]
    ++ lib.optionals pythonSupport [ pythonPackages.numpy ]
    ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ]
    ++ lib.optionals cudaSupport cudaComponents;

  cmakeFlags =
    [
      (lib.cmakeBool "FAISS_ENABLE_GPU" cudaSupport)
      (lib.cmakeBool "FAISS_ENABLE_PYTHON" pythonSupport)
      (lib.cmakeFeature "FAISS_OPT_LEVEL" optLevel)
    ]
    ++ lib.optionals cudaSupport [
      (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" flags.cmakeCudaArchitecturesString)
    ];

  buildFlags =
    [ "faiss" ]
    # This is just a demo app used as a test.
    # Disabled because linkage fails:
    # https://github.com/facebookresearch/faiss/issues/3484
    ++ lib.optionals (!cudaSupport) [ "demo_ivfpq_indexing" ]
    ++ lib.optionals pythonSupport [ "swigfaiss" ];

  # pip wheel->pip install commands copied over from opencv4

  postBuild = lib.optionalString pythonSupport ''
    (cd faiss/python &&
     python -m pip wheel --verbose --no-index --no-deps --no-clean --no-build-isolation --wheel-dir dist .)
  '';

  postInstall =
    ''
      mkdir -p $demos/bin
      if [[ "$buildInputs" == *demo_ivfpq_indexing* ]] ; then
        cp ./demos/demo_ivfpq_indexing $demos/bin/
      fi
    ''
    + lib.optionalString pythonSupport ''
      mkdir "$dist"
      cp faiss/python/dist/*.whl "$dist/"
    '';

  passthru = {
    inherit cudaSupport cudaPackages pythonSupport;

    tests = {
      runDemos =
        runCommand "${pname}-run-demos" { buildInputs = [ faiss.demos ]; }
          # There are more demos, we run just the one that documentation mentions
          ''
            demo_ivfpq_indexing && touch $out
          '';
      pythonFaiss = pythonPackages.faiss;
      pytest = pythonPackages.faiss.tests.pytest;
    };
  };

  meta = {
    description = "Library for efficient similarity search and clustering of dense vectors by Facebook Research";
    mainProgram = "demo_ivfpq_indexing";
    homepage = "https://github.com/facebookresearch/faiss";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
    # error: use of undeclared identifier 'SWIGTYPE_p_long'
    broken = stdenv.isDarwin;
  };
}
