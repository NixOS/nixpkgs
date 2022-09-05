{ lib
, config
, fetchFromGitHub
, stdenv
, cmake
, cudaPackages
, cudaSupport ? config.cudaSupport or false
, cudaCapabilities ? [ "60" "70" "80" "86" ]
, pythonSupport ? true
, pythonPackages
, blas
, swig
, addOpenGLRunpath
, optLevel ? let
    optLevels =
      lib.optional stdenv.hostPlatform.avx2Support "avx2"
      ++ lib.optional stdenv.hostPlatform.sse4_1Support "sse4"
      ++ [ "generic" ];
  in
  # Choose the maximum available optimization level
  builtins.head optLevels
, faiss # To run demos in the tests
, runCommand
}:

let
  pname = "faiss";
  version = "1.7.2";
  inherit (cudaPackages) cudatoolkit;
in
stdenv.mkDerivation {
  inherit pname version;

  outputs = [ "out" "demos" ];

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Tklf5AaqJbOs9qtBZVcxXPLAp+K54EViZLSOvEhmswg=";
  };

  buildInputs = [
    blas
    swig
  ] ++ lib.optionals pythonSupport [
    pythonPackages.setuptools
    pythonPackages.pip
    pythonPackages.wheel
  ];

  propagatedBuildInputs = lib.optionals pythonSupport [
    pythonPackages.numpy
  ];

  nativeBuildInputs = [ cmake ] ++ lib.optionals cudaSupport [
    cudatoolkit
    addOpenGLRunpath
  ] ++ lib.optional pythonSupport [
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
    "-DCMAKE_CUDA_ARCHITECTURES=${lib.concatStringsSep ";" cudaCapabilities}"
  ];


  # pip wheel->pip install commands copied over from opencv4

  buildPhase = ''
    make -j faiss
    make demo_ivfpq_indexing
  '' + lib.optionalString pythonSupport ''
    make -j swigfaiss
    (cd faiss/python &&
     python -m pip wheel --verbose --no-index --no-deps --no-clean --no-build-isolation --wheel-dir dist .)
  '';

  installPhase = ''
    make install
    mkdir -p $demos/bin
    cp ./demos/demo_ivfpq_indexing $demos/bin/
  '' + lib.optionalString pythonSupport ''
    mkdir -p $out/${pythonPackages.python.sitePackages}
    (cd faiss/python && python -m pip install dist/*.whl --no-index --no-warn-script-location --prefix="$out" --no-cache)
  '';

  fixupPhase = lib.optionalString (pythonSupport && cudaSupport) ''
    addOpenGLRunpath $out/${pythonPackages.python.sitePackages}/faiss/*.so
    addOpenGLRunpath $demos/bin/*
  '';

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
    description = "A library for efficient similarity search and clustering of dense vectors by Facebook Research";
    homepage = "https://github.com/facebookresearch/faiss";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
