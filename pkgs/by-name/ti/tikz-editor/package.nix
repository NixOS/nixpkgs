{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  nodejs,
  npmHooks,
  fetchNpmDeps,
  cargo-tauri,
  pkg-config,
  wrapGAppsHook4,
  webkitgtk_4_1,
  apple-sdk_15,
  zenity,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tikz-editor";
  version = "1.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    name = "${finalAttrs.pname}-${finalAttrs.version}-source";
    owner = "DominikPeters";
    repo = "tikz-editor";
    tag = "app-v${finalAttrs.version}";
    hash = "sha256-8WJ7SPxuMmx0LL/sEOmvhCUtf2qz3utA72gj1m0B520=";
  };

  cargoRoot = "apps/desktop/src-tauri";
  cargoHash = "sha256-runsvD87qUKjhCI7YV3oBE1Slz4AFi0DbC18h+bZH7s=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-NLLbJbi0jDOzcMeV3JSNUpfI6EvD+LVYAyZtAhc9A2g=";
  };

  preBuild = ''
    patchShebangs --build apps/desktop/node_modules
    buildAndTestSubdir=$cargoRoot
  '';

  tauriBuildFlags = [ "--no-sign" ];

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      webkitgtk_4_1
    ]
    # macOS 15 SDK: the Tauri/objc2 stack references AXPrefersNonBlinkingTextInsertionIndicator, a macOS 15 Accessibility symbol absent from the default SDK.
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_15
    ];

  # tikz-editor shells out to zenity for message dialogs (e.g. the unsaved changes prompt)
  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    gappsWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ zenity ]})
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "WYSIWYG editor for TikZ diagrams in LaTeX";
    homepage = "https://tikz.dev/editor/";
    changelog = "https://github.com/DominikPeters/tikz-editor/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.haansn08 ];
    mainProgram = "tikz-editor";
    platforms = lib.platforms.all;
  };
})
