{ lib
, stdenv
, buildPackages
}:

let
  # Codegen tool written by GHC upstream to generate the source for their port of
  # libffi for wasm
  libffi-wasm = buildPackages.haskellPackages.libffi-wasm;
in

stdenv.mkDerivation (finalAttrs: {
  inherit (libffi-wasm) pname version src;

  nativeBuildInputs = [
    libffi-wasm
  ];

  dontConfigure = true;

  CFLAGS = [
    "-Wall"
    "-Wextra"
    "-DNDEBUG"
    "-O3"
    "-Icbits"
  ];

  # Based on https://gitlab.haskell.org/ghc/libffi-wasm/-/blob/master/.gitlab-ci.yml
  buildPhase = ''
    runHook preBuild

    set -x

    libffi-wasm

    for f in cbits/ffi cbits/ffi_call cbits/ffi_closure; do
      $CC $CFLAGS -c "$f.c" -o "$f.o"
    done

    $AR -rc libffi.a cbits/*.o

    set +x

    runHook postBuild
  '';

  outputs = [ "out" "dev" ];
  installPhase = ''
    runHook preInstall

    install -Dm644 -t "$dev/include" cbits/*.h
    install -Dm755 -t "$out/lib" libffi.a

    runHook postInstall
  '';

  meta = {
    inherit (libffi-wasm.meta) maintainers license homepage;
    platforms = lib.platforms.wasi;
  };
})
