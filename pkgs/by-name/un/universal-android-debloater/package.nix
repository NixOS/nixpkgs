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
  wayland,
  makeWrapper,
  mold,
  pkg-config,
  rustPlatform,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "universal-android-debloater";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Universal-Debloater-Alliance";
    repo = "universal-android-debloater-next-generation";
    rev = "v${version}";
    hash = "sha256-o54gwFl2x0/nE1hiE5F8D18vQSNCKU9Oxiq8RA+yOoE=";
  };

  cargoHash = "sha256-Zm0zC9GZ2IsjVp5Phd38UAiBH8n0O/i56CEURBUapAg=";

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
  ];

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  postInstall = ''
    wrapProgram $out/bin/uad-ng \
      --prefix LD_LIBRARY_PATH : ${
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
      } \
      --suffix PATH : ${lib.makeBinPath [ android-tools ]}
  '';

  meta = {
    description = "Tool to debloat non-rooted Android devices";
    changelog = "https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/blob/${src.rev}/CHANGELOG.md";
    homepage = "https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation";
    license = lib.licenses.gpl3Only;
    mainProgram = "uad-ng";
    maintainers = with lib.maintainers; [ lavafroth ];
    platforms = lib.platforms.linux;
  };
}
