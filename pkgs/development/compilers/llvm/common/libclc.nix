{
  lib,
  stdenv,
  version,
  runCommand,
  monorepoSrc,
  llvm,
  buildPackages,
  buildLlvmTools,
  ninja,
  cmake,
  python3,
  release_version,
  getVersionFile,
}:
let
  spirv-llvm-translator = buildPackages.spirv-llvm-translator.override {
    inherit (buildLlvmTools) llvm;
  };

  # The build requires an unwrapped clang but wrapped clang++ thus we need to
  # split the unwrapped clang out to prevent the build from finding the
  # unwrapped clang++
  clang-only = runCommand "clang-only" { } ''
    mkdir -p "$out"/bin
    ln -s "${lib.getExe' buildLlvmTools.clang.cc "clang"}" "$out"/bin
  '';
in
stdenv.mkDerivation rec {
  pname = "libclc";
  inherit version;

  src = runCommand "${pname}-src-${version}" { inherit (monorepoSrc) passthru; } (
    ''
      mkdir -p "$out"
    ''
    + lib.optionalString (lib.versionAtLeast release_version "14") ''
      cp -r ${monorepoSrc}/cmake "$out"
    ''
    + ''
      cp -r ${monorepoSrc}/${pname} "$out"
    ''
  );

  sourceRoot = "${src.name}/${pname}";

  outputs = [
    "out"
    "dev"
  ];

  patches =
    [ ./libclc/libclc-gnu-install-dirs.patch ]
    # LLVM 19 changes how host tools are looked up.
    # Need to remove NO_DEFAULT_PATH and the PATHS arguments for find_program
    # so CMake can actually find the tools in nativeBuildInputs.
    # https://github.com/llvm/llvm-project/pull/105969
    ++ lib.optional (lib.versionAtLeast release_version "19") (
      getVersionFile "libclc/use-default-paths.patch"
    );

  # cmake expects all required binaries to be in the same place, so it will not be able to find clang without the patch
  postPatch =
    lib.optionalString (lib.versionOlder release_version "19") ''
      substituteInPlace CMakeLists.txt \
        --replace 'find_program( LLVM_CLANG clang PATHS ''${LLVM_TOOLS_BINARY_DIR} NO_DEFAULT_PATH )' \
                  'find_program( LLVM_CLANG clang PATHS "${buildLlvmTools.clang.cc}/bin" NO_DEFAULT_PATH )' \
        --replace 'find_program( LLVM_AS llvm-as PATHS ''${LLVM_TOOLS_BINARY_DIR} NO_DEFAULT_PATH )' \
                  'find_program( LLVM_AS llvm-as PATHS "${buildLlvmTools.llvm}/bin" NO_DEFAULT_PATH )' \
        --replace 'find_program( LLVM_LINK llvm-link PATHS ''${LLVM_TOOLS_BINARY_DIR} NO_DEFAULT_PATH )' \
                  'find_program( LLVM_LINK llvm-link PATHS "${buildLlvmTools.llvm}/bin" NO_DEFAULT_PATH )' \
        --replace 'find_program( LLVM_OPT opt PATHS ''${LLVM_TOOLS_BINARY_DIR} NO_DEFAULT_PATH )' \
                  'find_program( LLVM_OPT opt PATHS "${buildLlvmTools.llvm}/bin" NO_DEFAULT_PATH )' \
        --replace 'find_program( LLVM_SPIRV llvm-spirv PATHS ''${LLVM_TOOLS_BINARY_DIR} NO_DEFAULT_PATH )' \
                  'find_program( LLVM_SPIRV llvm-spirv PATHS "${spirv-llvm-translator}/bin" NO_DEFAULT_PATH )'
    ''
    + lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) (
      if (lib.versionOlder release_version "19") then
        ''
          substituteInPlace CMakeLists.txt \
            --replace 'COMMAND prepare_builtins' \
                      'COMMAND ${buildLlvmTools.libclc.dev}/bin/prepare_builtins'
        ''
      else
        ''
          substituteInPlace CMakeLists.txt \
            --replace-fail 'set( prepare_builtins_exe prepare_builtins )' \
                           'set( prepare_builtins_exe ${buildLlvmTools.libclc.dev}/bin/prepare_builtins )'
        ''
    );

  nativeBuildInputs =
    [
      cmake
      ninja
      python3
    ]
    ++ lib.optional (lib.versionAtLeast release_version "19") [
      clang-only
      buildLlvmTools.llvm
      spirv-llvm-translator
    ];
  buildInputs = [ llvm ];
  strictDeps = true;

  postInstall = ''
    install -Dt $dev/bin prepare_builtins
  '';

  meta = with lib; {
    homepage = "http://libclc.llvm.org/";
    description = "Implementation of the library requirements of the OpenCL C programming language";
    mainProgram = "prepare_builtins";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
