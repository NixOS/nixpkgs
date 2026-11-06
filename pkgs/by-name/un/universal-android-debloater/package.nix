{
  android-tools,
  clang,
  dbus,
  fetchFromGitHub,
  fontconfig,
  freetype,
  lib,
  stdenv,
  vulkan-loader,
  libglvnd,
  libxkbcommon,
  makeWrapper,
  nix-update-script,
  pkg-config,
  rustPlatform,
  wayland,
  writableTmpDirAsHomeHook,
  libxrandr,
  libxi,
  libxcursor,
  libx11,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "universal-android-debloater";
  version = "1.3.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Universal-Debloater-Alliance";
    repo = "universal-android-debloater-next-generation";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Gymqdult2MUwFMF3qQ4nwRd+aLEGGLLG60NOqR/VI7E=";
  };

  cargoHash = "sha256-sqbUuQV15KrwLg8QrcVxs1ejvRW9x6nYT+Q61tqpgIE=";

  cargoBuildFlags = [ "--package=uad-gui" ];
  cargoTestFlags = [
    "--package=uad-gui"
    "--package=uad-core"
  ];

  # Application updates are managed by Nix.
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "wgpu"
    "img"
  ];

  buildInputs = [
    fontconfig
    freetype
  ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  nativeCheckInputs = [
    clang
    writableTmpDirAsHomeHook
  ];

  postInstall = ''
    wrapProgram $out/bin/uad-ng --prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath (
        [
          dbus
          fontconfig
          freetype
          libglvnd
          libxkbcommon
          libx11
          libxcursor
          libxi
          libxrandr
        ]
        ++ lib.optionals stdenv.hostPlatform.isLinux [
          vulkan-loader
          wayland
        ]
      )
    } --suffix PATH : ${lib.makeBinPath [ android-tools ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/releases/tag/v${finalAttrs.version}";
    description = "Graphical tool to debloat non-rooted Android devices";
    homepage = "https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation";
    license = lib.licenses.gpl3Only;
    mainProgram = "uad-ng";
    maintainers = with lib.maintainers; [
      lavafroth
      iamanaws
    ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
