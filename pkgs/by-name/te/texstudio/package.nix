{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qt6,
  qt6Packages,
  hunspell,
  zlib,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "texstudio";
  version = "4.9.2";

  src = fetchFromGitHub {
    owner = "texstudio-org";
    repo = "texstudio";
    rev = finalAttrs.version;
    hash = "sha256-u4+QUL3bOGo81+8adovqkpCKw3H6Mw6I2V3PfcKhb60=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    pkg-config
  ];
  buildInputs = [
    hunspell
    qt6.qt5compat
    qt6.qtbase
    qt6.qtsvg
    qt6.qttools
    qt6Packages.poppler
    qt6Packages.quazip
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qt6.qtwayland
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications"
    mv "$out/bin/texstudio.app" "$out/Applications"
    rm -d "$out/bin"
  '';

  meta = {
    description = "TeX and LaTeX editor";
    longDescription = ''
      Fork of TeXMaker, this editor is a full fledged IDE for
      LaTeX editing with completion, structure viewer, preview,
      spell checking and support of any compilation chain.
    '';
    homepage = "https://texstudio.org";
    changelog = "https://github.com/texstudio-org/texstudio/blob/${finalAttrs.version}/utilities/manual/source/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      ajs124
      cfouche
    ];
    mainProgram = "texstudio";
  };
})
