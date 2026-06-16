{
  stdenvNoLibc,
  cmake,
  fetchFromGitHub,
  lib,
  lld,
  llvmPackages,
  wasm-component-ld,
  wasm-tools,
  wit-bindgen,
  wkg,
  firefox-unwrapped,
  firefox-esr-unwrapped,
}:

stdenvNoLibc.mkDerivation (finalAttrs: {
  pname = "wasilibc";
  version = "32";

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
    wasm-component-ld
    wasm-tools
    wit-bindgen
    wkg
  ];

  # These flags break pkgsCross.wasi32.llvmPackages.libcxx
  hardeningDisable = [
    "libcxxhardeningfast"
    "libcxxhardeningextensive"
  ];

  outputs = [
    "out"
    "dev"
  ];

  cmakeFlags = [
    "-DBUILTINS_LIB=${llvmPackages.compiler-rt}/lib/wasi/libclang_rt.builtins-wasm32.a"
    # CMake probes cc to try and detect brokenness, but it tries ordinary compilation that
    # depends on having a libc... which isn't there, as we're building the libc that's to
    # be used by the platform. Just skipping these checks makes the right thing happen.
    "-DCMAKE_C_COMPILER_FORCED=TRUE"
    "-DTARGET_TRIPLE=${stdenvNoLibc.system}"
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
