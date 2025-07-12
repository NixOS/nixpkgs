{
  stdenv,
  buildPackages,
  fetchFromGitHub,
  lib,
  firefox-unwrapped,
  firefox-esr-unwrapped,
}:

let
  pname = "wasilibc";
  version = "25-unstable-2025-05-13";
in
stdenv.mkDerivation {
  inherit pname version;

  src = buildPackages.fetchFromGitHub {
    owner = "WebAssembly";
    repo = "wasi-libc";
    rev = "6b2d6bd4db22cfd56762de24d9af7df04e6c1d46";
    hash = "sha256-D0WEWDF9W3ZlyITbJgWBL0JeVz+hwjNePlL+qzS2FAE=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "dev"
    "share"
  ];

  # clang-13: error: argument unused during compilation: '-rtlib=compiler-rt' [-Werror,-Wunused-command-line-argument]
  postPatch = ''
    substituteInPlace Makefile \
      --replace "-Werror" ""
    patchShebangs scripts/install-include-headers.sh
    # Simple fix for https://github.com/WebAssembly/wasi-libc/issues/583
    sed -i 's|BULK_MEMORY_THRESHOLD|20|g' \
      libc-top-half/musl/src/string/memmove.c \
      libc-top-half/musl/src/string/memset.c \
      libc-top-half/musl/src/string/memcpy.c
  '';

  preBuild = ''
    export SYSROOT_LIB=${builtins.placeholder "out"}/lib
    export SYSROOT_INC=${builtins.placeholder "dev"}/include
    export SYSROOT_SHARE=${builtins.placeholder "share"}/share
    mkdir -p "$SYSROOT_LIB" "$SYSROOT_INC" "$SYSROOT_SHARE"
    makeFlagsArray+=(
      "SYSROOT_LIB:=$SYSROOT_LIB"
      "SYSROOT_INC:=$SYSROOT_INC"
      "SYSROOT_SHARE:=$SYSROOT_SHARE"
      # https://bugzilla.mozilla.org/show_bug.cgi?id=1773200
      "BULK_MEMORY_SOURCES:="
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
    changelog = "https://github.com/WebAssembly/wasi-sdk/releases/tag/wasi-sdk-${version}";
    description = "WASI libc implementation for WebAssembly";
    homepage = "https://wasi.dev";
    platforms = platforms.wasi;
    maintainers = with maintainers; [
      matthewbauer
      rvolosatovs
    ];
    license = with licenses; [
      asl20
      llvm-exception
      mit
    ];
  };
}
