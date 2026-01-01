{
  lib,
  stdenv,
  cmake,
  python3,
  fetchFromGitHub,
  emscripten,
  gtest,
  lit,
  nodejs,
  filecheck,
}:
let
  testsuite = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "testsuite";
<<<<<<< HEAD
    rev = "4b24564c844e3d34bf46dfcb3c774ee5163e31cc";
    hash = "sha256-8VirKLRro0iST58Rfg17u4tTO57KNC/7F/NB43dZ7w4=";
=======
    rev = "e05365077e13a1d86ffe77acfb1a835b7aa78422";
    hash = "sha256-yvZ5AZTPUA6nsD3xpFC0VLthiu2CxVto66RTXBXXeJM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
in
stdenv.mkDerivation rec {
  pname = "binaryen";
<<<<<<< HEAD
  version = "125";
=======
  version = "124";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "version_${version}";
<<<<<<< HEAD
    hash = "sha256-QG8ZhvjcTbhIfYkVfrjxd97v9KaG/A8jO69rPg99/ME=";
=======
    hash = "sha256-tkvO0gNESliRV6FOpXDQd7ZKujGe6q1mGX5V+twcE1o=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  strictDeps = true;

  preConfigure = ''
    if [ $doCheck -eq 1 ]; then
      sed -i '/gtest/d' third_party/CMakeLists.txt
      rmdir test/spec/testsuite
      ln -s ${testsuite} test/spec/testsuite
    else
      cmakeFlagsArray=($cmakeFlagsArray -DBUILD_TESTS=0)
    fi
  '';

  nativeCheckInputs = [
    lit
    nodejs
    filecheck
  ];
  checkInputs = [ gtest ];
  checkPhase = ''
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/lib python3 ../check.py $tests
  '';

  tests = [
    "version"
    "wasm-opt"
    "wasm-dis"
    "crash"
    "dylink"
    "ctor-eval"
    "wasm-metadce"
    "wasm-reduce"
    "spec"
    "lld"
    "wasm2js"
    # "unit" # fails on test.unit.test_cluster_fuzz.ClusterFuzz
    # "binaryenjs" "binaryenjs_wasm" # not building this
    # "lit" # fails on d8/fuzz_shell*
    "gtest"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "example"
    "validator"
  ];

  doCheck = (stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isDarwin);

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/WebAssembly/binaryen";
    description = "Compiler infrastructure and toolchain library for WebAssembly, in C++";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      asppsa
      willcohen
    ];
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    homepage = "https://github.com/WebAssembly/binaryen";
    description = "Compiler infrastructure and toolchain library for WebAssembly, in C++";
    platforms = platforms.all;
    maintainers = with maintainers; [
      asppsa
      willcohen
    ];
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
  passthru.tests = { inherit emscripten; };
}
