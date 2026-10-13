{
  stdenvNoLibc,
  cmake,
  fetchFromGitHub,
  lib,
  lld,
  llvmPackages,
  ninja,
  wasm-tools,
  wit-bindgen,
  wkg,
  firefox-unwrapped,
  firefox-esr-unwrapped,
}:

stdenvNoLibc.mkDerivation (finalAttrs: {
  pname = "wasilibc";
  version = "32";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "wasi-libc";
    tag = "wasi-sdk-${finalAttrs.version}";
    hash = "sha256-iP/SFYvO8zQMwwbY4VvIboO+Kx195L9brpMq8cbsA7c=";
    fetchSubmodules = true;
  };

  patches = [
    ./0000-relax-version-bounds.patch
  ];

  nativeBuildInputs = [
    cmake
    lld
    ninja
    wasm-tools
    wit-bindgen
    wkg
  ];

  outputs = [
    "out"
    "dev"
  ];

  cmakeFlags = [
    (lib.cmakeFeature "BUILTINS_LIB" "${llvmPackages.compiler-rt}/lib/${stdenvNoLibc.targetPlatform.parsed.kernel.name}/libclang_rt.builtins-wasm32.a")
    #https://stackoverflow.com/questions/53633705/cmake-the-c-compiler-is-not-able-to-compile-a-simple-test-program
    (lib.cmakeFeature "CMAKE_TRY_COMPILE_TARGET_TYPE" "STATIC_LIBRARY")
    (lib.cmakeFeature "TARGET_TRIPLE" stdenvNoLibc.system)
    # clang already knows to use wasm-component-ld to link
    (lib.cmakeFeature "USE_WASM_COMPONENT_LD" "OFF")
  ];

  enableParallelBuilding = true;

  preFixup =
    lib.optionalString (stdenvNoLibc.system != stdenvNoLibc.targetPlatform.rust.rustcTargetSpec)
      ''
        ln -s $out/lib/${stdenvNoLibc.system} $out/lib/${stdenvNoLibc.targetPlatform.rust.rustcTargetSpec}
      '';

  # TODO: run wasilibc tests. Nixpkgs never runs the check phase during cross compiles
  # (sensibly), but this package is always cross compiled due to its nature, and the tests
  # expect to be run in a cross-compilation environment. There are instructions on how to run
  # them but I don't understand enough about Nixpkgs' CMake set-up to work out how to apply them.

  passthru = {
    incdir = "/include/${stdenvNoLibc.system}";
    libdir = "/lib/${stdenvNoLibc.system}";
    tests = {
      inherit firefox-unwrapped firefox-esr-unwrapped;
    };
  };

  meta = {
    changelog = "https://github.com/WebAssembly/wasi-sdk/releases/tag/wasi-sdk-${finalAttrs.version}";
    description = "WASI libc implementation for WebAssembly";
    homepage = "https://wasi.dev";
    platforms = lib.platforms.wasi;
    maintainers = with lib.maintainers; [
      rvolosatovs
      wucke13
    ];
    license = with lib.licenses; [
      asl20
      llvm-exception
      mit
    ];
  };
})
