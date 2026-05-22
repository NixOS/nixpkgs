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
    rev = "4b24564c844e3d34bf46dfcb3c774ee5163e31cc";
    hash = "sha256-8VirKLRro0iST58Rfg17u4tTO57KNC/7F/NB43dZ7w4=";
  };
in
stdenv.mkDerivation rec {
  pname = "binaryen";
  version = "129";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "version_${version}";
    hash = "sha256-rmCNBrKHVozjzyWPAD4pZw0uViMMRRQsZALm4jbYIJk=";
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
      # scripts/test/lld.py checks `'64' in input_path` to enable the
      # memory64/bigint flags; the full Nix build path leaks digits that
      # can accidentally contain "64", wrongly triggering those flags for
      # non-memory64 tests (e.g. duplicate_imports.wat). Match on basename.
      substituteInPlace scripts/test/lld.py \
        --replace-fail "'64' in input_path" "'64' in os.path.basename(input_path)"
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
      willcohen
    ];
    license = lib.licenses.asl20;
  };
  passthru.tests = { inherit emscripten; };
}
