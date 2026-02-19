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
  libxrandr,
  libxi,
  libxcursor,
  libx11,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "universal-android-debloater";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Universal-Debloater-Alliance";
    repo = "universal-android-debloater-next-generation";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TGelOjwqTzYShZxXyPTTfkjAreFmZmrCF7jtp1UAfDw=";
  };

  cargoHash = "sha256-RutiCWTkXnF7W86SnXRs+vI7dELrbdZXI62J8suZv5g=";

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
        libx11
        libxcursor
        libxi
        libxrandr
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
