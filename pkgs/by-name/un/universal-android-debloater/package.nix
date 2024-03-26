{ android-tools
, clang
, expat
, fetchFromGitHub
, fontconfig
, freetype
, lib
, libglvnd
, makeWrapper
, mold
, pkg-config
, rustPlatform
, xorg
}:
rustPlatform.buildRustPackage rec {
  pname = "universal-android-debloater";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "Universal-Debloater-Alliance";
    repo = "universal-android-debloater-next-generation";
    rev = "v${version}";
    hash = "sha256-yiCl6inPFveMO4IA2NwwpEmbRSmrZBeZR+eiKzGj6a0=";
  };

  cargoHash = "sha256-HqyOslcr3pwDvpZ8CNbAy2W5jGhWGWoe/rutq0leNaY=";

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
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ fontconfig freetype libglvnd xorg.libX11 xorg.libXcursor xorg.libXi xorg.libXrandr ]} \
      --suffix PATH : ${lib.makeBinPath [ android-tools ]}
  '';

  meta = with lib; {
    description = "A tool to debloat non-rooted Android devices";
    changelog = "https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/blob/${src.rev}/CHANGELOG.md";
    homepage = "https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation";
    license = licenses.gpl3Only;
    mainProgram = "uad-ng";
    maintainers = with maintainers; [ xfix ];
    platforms = platforms.linux;
  };
}
