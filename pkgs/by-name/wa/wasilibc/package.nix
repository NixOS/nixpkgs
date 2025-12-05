{
  stdenvNoLibc,
  fetchFromGitHub,
  lib,
  firefox-unwrapped,
  firefox-esr-unwrapped,
  enablePosixThreads ? false,
}:

stdenvNoLibc.mkDerivation (finalAttrs: {
  pname = "wasilibc";
  version = "27";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "wasi-libc";
    tag = "wasi-sdk-${finalAttrs.version}";
    hash = "sha256-RIjph1XdYc1aGywKks5JApcLajbNFEuWm+Wy/GMHddg=";
    fetchSubmodules = true;
  };

  # These flags break pkgsCross.wasi32.llvmPackages.libcxx
  hardeningDisable = [
    "libcxxhardeningfast"
    "libcxxhardeningextensive"
  ];

  outputs = [
    "out"
    "dev"
    "share"
  ];

  # clang-13: error: argument unused during compilation: '-rtlib=compiler-rt' [-Werror,-Wunused-command-line-argument]
  postPatch = ''
    substituteInPlace Makefile \
      --replace "-Werror" ""
    patchShebangs scripts/
  '';

  preBuild = ''
    export SYSROOT_LIB=${placeholder "out"}/lib
    export SYSROOT_INC=${placeholder "dev"}/include
    export SYSROOT_SHARE=${placeholder "share"}/share
    mkdir -p "$SYSROOT_LIB" "$SYSROOT_INC" "$SYSROOT_SHARE"
    makeFlagsArray+=(
      "SYSROOT_LIB:=$SYSROOT_LIB"
      "SYSROOT_INC:=$SYSROOT_INC"
      "SYSROOT_SHARE:=$SYSROOT_SHARE"
      ${lib.strings.optionalString enablePosixThreads "THREAD_MODEL:=posix"}
    )
  '';

  enableParallelBuilding = true;

  # We just build right into the install paths, per the `preBuild`.
  dontInstall = true;

  preFixup = ''
    ln -s $share/share/undefined-symbols.txt $out/lib/wasi.imports
  '';

  passthru.tests = {
    inherit firefox-unwrapped firefox-esr-unwrapped;
  };

  meta = with lib; {
    changelog = "https://github.com/WebAssembly/wasi-sdk/releases/tag/wasi-sdk-${finalAttrs.version}";
    description = "WASI libc implementation for WebAssembly";
    homepage = "https://wasi.dev";
    platforms = platforms.wasi;
    maintainers = with maintainers; [
      rvolosatovs
      wucke13
    ];
    license = with licenses; [
      asl20
      llvm-exception
      mit
    ];
  };
})
