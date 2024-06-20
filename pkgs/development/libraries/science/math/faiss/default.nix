{ lib
, config
, fetchFromGitHub
, symlinkJoin
, stdenv
, cmake
, cudaPackages ? { }
, cudaSupport ? config.cudaSupport
, pythonSupport ? true
, pythonPackages
, llvmPackages
, boost
, blas
, swig
, addOpenGLRunpath
, optLevel ? let
    optLevels =
      lib.optionals stdenv.hostPlatform.avx2Support [ "avx2" ]
      ++ lib.optionals stdenv.hostPlatform.sse4_1Support [ "sse4" ]
      ++ [ "generic" ];
  in
  # Choose the maximum available optimization level
  builtins.head optLevels
, faiss # To run demos in the tests
, runCommand
}@inputs:

let
  pname = "faiss";
  version = "1.7.4";

  inherit (cudaPackages) cudaFlags backendStdenv;
  inherit (cudaFlags) cudaCapabilities dropDot;

  stdenv = if cudaSupport then backendStdenv else inputs.stdenv;

  cudaJoined = symlinkJoin {
    name = "cuda-packages-unsplit";
    paths = with cudaPackages; [
      cuda_cudart # cuda_runtime.h
      libcublas
      libcurand
      cuda_cccl
    ] ++ lib.optionals (cudaPackages ? cuda_profiler_api) [
      cuda_profiler_api # cuda_profiler_api.h
    ] ++ lib.optionals (!(cudaPackages ? cuda_profiler_api)) [
      cuda_nvprof # cuda_profiler_api.h
    ];
  };
in
stdenv.mkDerivation {
  inherit pname version;

  outputs = [ "out" "demos" ];

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WSce9X6sLZmGM5F0ZkK54VqpIy8u1VB0e9/l78co29M=";
  };

  buildInputs = [
    blas
    swig
  ] ++ lib.optionals pythonSupport [
    pythonPackages.setuptools
    pythonPackages.pip
    pythonPackages.wheel
  ] ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ] ++ lib.optionals cudaSupport [
    cudaJoined
  ];

  propagatedBuildInputs = lib.optionals pythonSupport [
    pythonPackages.numpy
  ];

  nativeBuildInputs = [ cmake ] ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
    addOpenGLRunpath
  ] ++ lib.optionals pythonSupport [
    pythonPackages.python
  ];

  passthru.extra-requires.all = [
    pythonPackages.numpy
  ];

  cmakeFlags = [
    "-DFAISS_ENABLE_GPU=${if cudaSupport then "ON" else "OFF"}"
    "-DFAISS_ENABLE_PYTHON=${if pythonSupport then "ON" else "OFF"}"
    "-DFAISS_OPT_LEVEL=${optLevel}"
  ] ++ lib.optionals cudaSupport [
    "-DCMAKE_CUDA_ARCHITECTURES=${builtins.concatStringsSep ";" (map dropDot cudaCapabilities)}"
    "-DCUDAToolkit_INCLUDE_DIR=${cudaJoined}/include"
  ];

  buildFlags = [
    "faiss"
    "demo_ivfpq_indexing"
  ] ++ lib.optionals pythonSupport [
    "swigfaiss"
  ];

  # pip wheel->pip install commands copied over from opencv4

  postBuild = lib.optionalString pythonSupport ''
    (cd faiss/python &&
     python -m pip wheel --verbose --no-index --no-deps --no-clean --no-build-isolation --wheel-dir dist .)
  '';

  postInstall = ''
    mkdir -p $demos/bin
    cp ./demos/demo_ivfpq_indexing $demos/bin/
  '' + lib.optionalString pythonSupport ''
    mkdir -p $out/${pythonPackages.python.sitePackages}
    (cd faiss/python && python -m pip install dist/*.whl --no-index --no-warn-script-location --prefix="$out" --no-cache)
  '';

  postFixup = lib.optionalString (pythonSupport && cudaSupport) ''
    addOpenGLRunpath $out/${pythonPackages.python.sitePackages}/faiss/*.so
    addOpenGLRunpath $demos/bin/*
  '';

  # Need buildPythonPackage for this one
  # pythonImportsCheck = [
  #   "faiss"
  # ];

  passthru = {
    inherit cudaSupport cudaPackages pythonSupport;

    tests = {
      runDemos = runCommand "${pname}-run-demos"
        { buildInputs = [ faiss.demos ]; }
        # There are more demos, we run just the one that documentation mentions
        ''
          demo_ivfpq_indexing && touch $out
        '';
    } // lib.optionalAttrs pythonSupport {
      pytest = pythonPackages.callPackage ./tests.nix { };
    };
  };

  meta = with lib; {
    description = "Library for efficient similarity search and clustering of dense vectors by Facebook Research";
    mainProgram = "demo_ivfpq_indexing";
    homepage = "https://github.com/facebookresearch/faiss";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
