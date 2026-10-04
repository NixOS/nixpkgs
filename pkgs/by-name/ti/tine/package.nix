{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  cargo-tauri,
  nodejs,
  npmHooks,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tine";
  version = "0.6.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "martinkoutecky";
    repo = "tine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EP1tU1RNACpY3frS+5oNPKwrZ5mBszJx2yawnhia9Mg=";
  };

  cargoHash = "sha256-/zKrnBVN8O4uCWQ7Sz5dg3XY/BqrrViNHcadjWsTZPE=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-6hyzr7Tpc7PM+E6YYAdcnvwA+d5LUc9/RqNE0JuCoXw=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ];

  buildAndTestSubdir = "src-tauri";

  tauriBuildFlags = [ "--no-bundle" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/tine $out/bin/

    runHook postInstall
  '';

  meta = {
    description = "Fast, local, Logseq-compatible outliner";
    homepage = "https://github.com/martinkoutecky/tine";
    license = lib.licenses.agpl3Only;
    mainProgram = "tine";
    maintainers = with lib.maintainers; [ fcosanabria ];
    platforms = lib.platforms.linux;
  };
})
