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
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "Universal-Debloater-Alliance";
    repo = pname;
    rev = version;
    hash = "sha256-8s4/lAekW2glz4lH79UtbziToytT53m5wQGTVMBAqMU=";
  };

  cargoHash = "sha256-fMW9CmDyJ77PIuJ6QGI8nNZsuAZwkL9xf3xbbX13HKw=";

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
    wrapProgram $out/bin/uad_gui \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ fontconfig freetype libglvnd xorg.libX11 xorg.libXcursor xorg.libXi xorg.libXrandr ]} \
      --suffix PATH : ${lib.makeBinPath [ android-tools ]}
  '';

  meta = with lib; {
    description = "A tool to debloat non-rooted Android devices";
    changelog = "https://github.com/Universal-Debloater-Alliance/universal-android-debloater/blob/${src.rev}/CHANGELOG.md";
    homepage = "https://github.com/Universal-Debloater-Alliance/universal-android-debloater";
    license = licenses.gpl3Only;
    mainProgram = "uad_gui";
    maintainers = with maintainers; [ xfix ];
    platforms = platforms.linux;
  };
}
