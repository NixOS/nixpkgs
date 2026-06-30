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
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tikz-editor";
  version = "0.4.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "DominikPeters";
    repo = "tikz-editor";
    tag = "app-v${finalAttrs.version}";
    hash = "sha256-4rhlnjb04YRmImrKYkWk7+6bE3wec24BAKWZe2mfRTY=";
  };

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-ptiPjiWEv6xf109BHG7jumXIvVqE/wJgk4oIywBCLho=";
  };

  cargoRoot = "apps/desktop/src-tauri";
  cargoHash = "sha256-NzTLNtbkyKbFgetqSwxVR6VRGAjZiw1fyrxSUb5ucYA=";

  # don't call the binary "app"
  postPatch = ''
    substituteInPlace $cargoRoot/Cargo.toml \
      --replace-fail 'name = "app"' 'name = "${finalAttrs.pname}"'
  '';

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

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    webkitgtk_4_1
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
