# @vercel/python-analysis needs Rust's wasm32-wasip2 standard library, which
# Nixpkgs does not yet expose as a cross target. Adapt the wasip1 sysroot while
# reusing the native compiler. Nixpkgs builds Rust with --disable-lld, so Rust
# cannot use its bundled wasm-component-ld and needs an external linker.
# TODO: remove this helper when Nixpkgs provides a wasm32-wasip2 Rust sysroot.
{
  lib,
  pkgsCross,
  rustc,
  stdenv,
  wasm-component-ld,
}:

let
  wasi = pkgsCross.wasm32-wasip1;
  wasilibc = wasi.wasilibc.overrideAttrs (old: {
    cmakeFlags =
      map (lib.replaceStrings
        [ "-DTARGET_TRIPLE:STRING=wasm32-wasip1" ]
        [ "-DTARGET_TRIPLE:STRING=wasm32-wasip2" ]
      ) old.cmakeFlags
      # Rust links static libc into the component; shared libc is unused.
      ++ [ (lib.cmakeBool "BUILD_SHARED" false) ];
  });
  # Reuse Nixpkgs' WASI standard-library build with Rust's component target.
  # The compiler itself is reused from the native package set.
  sysroot = wasi.buildPackages.rustc.unwrapped.overrideAttrs (old: {
    pname = "rustc-wasip2";
    nativeBuildInputs = old.nativeBuildInputs ++ [ wasm-component-ld ];
    # Background on fastCross staging the native compiler libraries:
    # https://github.com/NixOS/nixpkgs/issues/317041
    # Its hard-coded .so suffix creates dangling links on Darwin, which uses .dylib.
    buildPhase =
      lib.replaceStrings [ ".so" ] [ stdenv.hostPlatform.extensions.sharedLibrary ]
        old.buildPhase;
    configureFlags = map (lib.replaceStrings
      [ "wasm32-wasip1" "${wasi.wasilibc}" ]
      [ "wasm32-wasip2" "${wasilibc}" ]
    ) old.configureFlags;
  });
in
rustc.override { inherit sysroot; }
