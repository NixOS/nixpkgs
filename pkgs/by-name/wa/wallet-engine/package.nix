{
  lib,
  stdenv,
  rustPlatform,
  buildPackages,
  fetchFromGitHub,
  fetchpatch2,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wallet-engine";
  version = "0.0.7-unstable-2026-10-02";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "i582";
    repo = "wallet-engine";
    rev = "e59e0d89d7ee90c388bf36e3334c5b276f396697";
    hash = "sha256-729W7YCjkUCdL8Xk8BPHKdjpK6F+x1C9wnk/17TGhx4=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/desktop-app/patches/raw/aec474953ff7ee9b6e4cd9b8658288ea86d124f3/wallet-engine.patch";
      hash = "sha256-uBkMl6P3v8RrLFuEtv6er4LmQB9CwMc8DWBjOJQEkIo=";
    })
  ];

  cargoHash = "sha256-b9LErZRUgVa/bHjmbN3ltW8vUoF9UhCjMAfFPSbpzbY=";

  passthru = {
    updateScript = nix-update-script { };
    bindgen-cpp = buildPackages.rustPlatform.buildRustPackage {
      pname = "wallet-engine-bindgen-cpp";
      inherit (finalAttrs) version src patches;
      __structuredAttrs = true;
      cargoRoot = "bindgen/cpp";
      buildAndTestSubdir = "bindgen/cpp";
      cargoHash = "sha256-n3VKg3OMU9a4fbaxISWKEVXRe9vRe63/GeRdpmDEZTM=";
      meta = finalAttrs.meta // {
        description = finalAttrs.meta.description + " - cpp binding generator";
        mainProgram = "uniffi-bindgen-cpp";
      };
    };
  };

  postInstall = ''
    ${lib.getExe finalAttrs.passthru.bindgen-cpp} \
      --library --out-dir "$out/include/wallet_engine" \
      "$out/lib/libwallet_engine${stdenv.hostPlatform.extensions.sharedLibrary}"
  '';

  # requires acton binary
  doCheck = false;

  meta = {
    description = "Cross-platform wallet engine for TON written in Rust";
    homepage = "https://github.com/i582/wallet-engine";
    changelog = "https://github.com/i582/wallet-engine/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
