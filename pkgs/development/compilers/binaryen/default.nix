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
  writeShellApplication,
  common-updater-scripts,
  curl,
  jq,
  nix,
  nix-update,
}:
let
  testsuite = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "testsuite";
    rev = "de54fd27ecf3e68dfd16b6199c548df77b6a2cc1";
    hash = "sha256-vjAGE1MnBi7hqfkQ+PVCdTno8muorAgSiDylnAHqKK4=";
  };
in
stdenv.mkDerivation rec {
  pname = "binaryen";
  version = "131";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "version_${version}";
    hash = "sha256-7x4I34sWNJIz0X7orJtjU4BQ1CLbIFtkUTqdy5MrxX0=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  strictDeps = true;

  preConfigure = ''
    if [ -n "$doCheck" ]; then
      sed -i '/gtest/d' third_party/CMakeLists.txt
      rmdir test/spec/testsuite
      ln -s ${testsuite} test/spec/testsuite
      # scripts/test/finalize.py checks `'64' in input_path` to enable the
      # memory64/bigint flags; the full Nix build path leaks digits that
      # can accidentally contain "64", wrongly triggering those flags for
      # non-memory64 tests (e.g. duplicate_imports.wat). Match on basename.
      substituteInPlace scripts/test/finalize.py \
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

  # bin/binaryen-unittests is absent on cross builds which don't have doCheck,
  # so delete it on non-cross builds too (thus removing gtest from the closure).
  postInstall = ''
    if [ -n "$doCheck" ]; then
      rm "$out/bin/binaryen-unittests"
    fi
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
    # "spec" # fails on array_init_elem.wast
    "finalize"
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
  passthru = {
    tests = { inherit emscripten; };
    inherit testsuite; # For updateScript to use.
    updateScript = lib.getExe (writeShellApplication {
      name = "binaryen-update";
      runtimeInputs = [
        common-updater-scripts
        curl
        jq
        nix
        nix-update
      ];
      text = ''
        nix-update binaryen

        # keep the testsuite pin on binaryen's submodule pointer at the new tag
        tag=$(nix eval --raw --file . binaryen.src.rev)
        rev=$(curl -fsSL "https://api.github.com/repos/WebAssembly/binaryen/contents/test/spec/testsuite?ref=$tag" | jq -er .sha)
        if [[ $rev != "$(nix eval --raw --file . binaryen.testsuite.rev)" ]]; then
          update-source-version binaryen --source-key=testsuite --rev="$rev" --ignore-same-version
        fi
      '';
    });
  };
}
