{
  lib,
  stdenv,
  cmake,
  python3,
  fetchFromGitHub,
  fetchpatch2,
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
    rev = "4b24564c844e3d34bf46dfcb3c774ee5163e31cc";
    hash = "sha256-8VirKLRro0iST58Rfg17u4tTO57KNC/7F/NB43dZ7w4=";
  };
in
stdenv.mkDerivation rec {
  pname = "binaryen";
  version = "125";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "version_${version}";
    hash = "sha256-QG8ZhvjcTbhIfYkVfrjxd97v9KaG/A8jO69rPg99/ME=";
  };

  patches = [
    # TODO: remove at next release
    # fix build on aarch64/riscv64 with gcc15 but bug exists on all platforms.
    (fetchpatch2 {
      name = "fix-uninitialized-small-vector.patch";
      # https://github.com/WebAssembly/binaryen/pull/8094
      url = "https://github.com/WebAssembly/binaryen/commit/3ff3762bf7c83edcdfccad522de640f2b0928ae2.patch?full_index=1";
      hash = "sha256-lhrXQJAaQ/4ofnpyVqhD08IuDxPRc7UPyZ8DoCfM9NE=";
    })
  ];

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

  meta = {
    homepage = "https://github.com/WebAssembly/binaryen";
    description = "Compiler infrastructure and toolchain library for WebAssembly, in C++";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      asppsa
      willcohen
    ];
    license = lib.licenses.asl20;
  };
  passthru.tests = { inherit emscripten; };
}
