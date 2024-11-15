{
  android-tools,
  clang,
  expat,
  fetchFromGitHub,
  fontconfig,
  freetype,
  lib,
  stdenv,
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

  passthru.updateScript = nix-update-script { };

  postInstall = ''
    wrapProgram $out/bin/uad-ng \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath (
          [
            fontconfig
            freetype
            libglvnd
            libxkbcommon
            xorg.libX11
            xorg.libXcursor
            xorg.libXi
            xorg.libXrandr
          ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [ wayland ]
        )
      } \
      --suffix PATH : ${lib.makeBinPath [ android-tools ]}
  '';

  meta = {
    changelog = "https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/releases/tag/v${finalAttrs.version}";
    description = "Tool to debloat non-rooted Android devices";
    homepage = "https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation";
    license = lib.licenses.gpl3Only;
    mainProgram = "uad-ng";
    maintainers = with lib.maintainers; [ lavafroth ];
    broken = with stdenv.hostPlatform; isDarwin && isx86_64;
    platforms = with lib.platforms; linux ++ darwin;
  };
})
