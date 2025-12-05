{
  android-tools,
  clang,
  expat,
  fetchFromGitHub,
  fontconfig,
  freetype,
  lib,
  libglvnd,
  libxkbcommon,
  makeWrapper,
  mold,
  nix-update-script,
  pkg-config,
  rustPlatform,
  wayland,
  writableTmpDirAsHomeHook,
  xorg,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "universal-android-debloater";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "Universal-Debloater-Alliance";
    repo = "universal-android-debloater-next-generation";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DapPUvkI4y159gYbSGJQbbDfW+C0Ggvaxo45Qj3mLrQ=";
  };

  cargoHash = "sha256-eXbReRi/0h4UyJwIMI3GfHcQzX1E5Spoa4moMXtrBng=";

  buildInputs = [
    expat
    fontconfig
    freetype
  ];

  nativeBuildInputs = [
    makeWrapper
    mold
    pkg-config
  ];

  nativeCheckInputs = [
    clang
    writableTmpDirAsHomeHook
  ];

  postInstall = ''
    wrapProgram $out/bin/uad-ng --prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        fontconfig
        freetype
        libglvnd
        libxkbcommon
        wayland
        xorg.libX11
        xorg.libXcursor
        xorg.libXi
        xorg.libXrandr
      ]
    } --suffix PATH : ${lib.makeBinPath [ android-tools ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/releases/tag/v${finalAttrs.version}";
    description = "Tool to debloat non-rooted Android devices";
    homepage = "https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation";
    license = lib.licenses.gpl3Only;
    mainProgram = "uad-ng";
    maintainers = with lib.maintainers; [ lavafroth ];
    platforms = lib.platforms.linux;
  };
})
