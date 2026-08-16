{
  stdenv,
  lib,
  rustPlatform,
  fetchFromCodeberg,
  pkg-config,
  zlib,
  cmake,

  nix-update-script,
  versionCheckHook,

  libx11,
  libxrandr,
  libxinerama,
  libxcursor,
  libxi,
  libglvnd,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "usagi";
  version = "1.3.0";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "brettchalupa";
    repo = "usagi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bGGcbkQIsJwRHhg0pizwq0Xfo11TkfTz1OWKke8Aj4E=";
  };

  cargoHash = "sha256-Tymk8PwkKumfMSR06CmiQ47nnldWuSiNwMwCyEwXgEs=";

  nativeBuildInputs = [
    pkg-config
    cmake
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libx11
    libxrandr
    libxinerama
    libxcursor
    libxi
    libglvnd
  ];

  checkFlags = [
    # skip tests that require networking
    "--skip=templates::tests::download_errors_on_404_with_status_and_url"
    "--skip=templates::tests::download_then_extract_then_locate_round_trip"
    "--skip=templates::tests::download_with_verify_errors_on_hash_mismatch"
    "--skip=templates::tests::download_with_verify_errors_when_sidecar_missing"
    "--skip=templates::tests::download_with_verify_passes_when_sidecar_matches"
    "--skip=templates::tests::download_writes_response_body_to_dest"
    "--skip=templates::tests::ensure_cached_fetches_extracts_on_cold_cache"
    "--skip=templates::tests::ensure_cached_forces_redownload_when_no_cache"
    "--skip=templates::tests::ensure_cached_surfaces_404_with_helpful_hint"
  ];

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux "patchelf --add-rpath ${
    lib.makeLibraryPath [ libglvnd ]
  } $out/bin/usagi";

  passthru.updateScript = nix-update-script { };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "2D game engine for making pixel art games in Lua 5.5";
    homepage = "https://usagiengine.com";
    changelog = "https://usagiengine.com/changelog";
    license = lib.licenses.unlicense;
    mainProgram = "usagi";
    maintainers = with lib.maintainers; [ chickenchunk ];
  };
})
