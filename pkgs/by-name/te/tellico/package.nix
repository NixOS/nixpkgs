{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  exempi,
  libcdio,
  makeWrapper,
  taglib,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tellico";
  version = "4.2.2";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "office";
    repo = "tellico";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6V5eM6XU2P5GJRkW2oNtUcDZH+4Wlsz+bivrsqWOw4M=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    kdePackages.kdoctools
    makeWrapper
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    exempi
    kdePackages.karchive
    kdePackages.kfilemetadata
    kdePackages.kitemmodels
    kdePackages.knewstuff
    kdePackages.kxmlgui
    libcdio
    kdePackages.libkcddb
    kdePackages.libksane
    kdePackages.poppler
    kdePackages.qtcharts
    kdePackages.qtwebengine
    kdePackages.solid
    taglib
  ];

  meta = {
    description = "Collection management software, free and simple";
    mainProgram = "tellico";
    homepage = "https://tellico-project.org/";
    license = with lib.licenses; [
      gpl2Only
      gpl3Only
      lgpl2Only
    ];
    maintainers = with lib.maintainers; [ numkem ];
    platforms = lib.platforms.linux;
  };
})
