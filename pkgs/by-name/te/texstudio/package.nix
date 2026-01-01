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
<<<<<<< HEAD
  version = "4.9.1";
=======
  version = "4.9.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "texstudio-org";
    repo = "texstudio";
    rev = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-lSAIlwdOVFd8pcT4rZ17Jn9195BOtZnUgFysDKM6t9U=";
=======
    hash = "sha256-LHG+QFtUYf6gqF8WGUlAYd5LWNt2YlyXmQH2nwPV5MQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "TeX and LaTeX editor";
    longDescription = ''
      Fork of TeXMaker, this editor is a full fledged IDE for
      LaTeX editing with completion, structure viewer, preview,
      spell checking and support of any compilation chain.
    '';
    homepage = "https://texstudio.org";
    changelog = "https://github.com/texstudio-org/texstudio/blob/${finalAttrs.version}/utilities/manual/source/CHANGELOG.md";
<<<<<<< HEAD
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
=======
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      ajs124
      cfouche
    ];
    mainProgram = "texstudio";
  };
})
