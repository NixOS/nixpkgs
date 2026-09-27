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
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tikz-editor";
  version = "0.5.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    name = "${finalAttrs.pname}-${finalAttrs.version}-source";
    owner = "DominikPeters";
    repo = "tikz-editor";
    tag = "app-v${finalAttrs.version}";
    hash = "sha256-6aTxRLENjFb0UzHsRS50oVvnremmhS+wesLNy0KCKQo=";
  };

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-sWOlLLs83AKPW+e79+4wiC3INERZVaKKTb/MJOj7Gt0=";
  };

  cargoRoot = "apps/desktop/src-tauri";
  cargoHash = "sha256-Mf06pOdUiex+JJumA8tlK2mPJSR7usGHQJ3EGR3dDnM=";

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
