{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  xxd,
  pkg-config,
  imagemagick,
  wrapGAppsHook3,
  gtk3,
  jansson,
  nixosTests,
}:

stdenv.mkDerivation {
  pname = "urn-timer";
  version = "0-unstable-2025-10-18";

  src = fetchFromGitHub {
    owner = "paoloose";
    repo = "urn";
    rev = "cae0763f7d5c0d895faf6d2ab7448d1b05b60dff";
    hash = "sha256-jG+Xibdsu53/aycUf/TzsQtegGY/buwswJ9ediZIJ4w=";
  };

  nativeBuildInputs = [
    xxd
    pkg-config
    imagemagick
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    jansson
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/paoloose/urn.git";
  };

  passthru.tests.nixosTest = nixosTests.urn-timer;

  meta = with lib; {
    homepage = "https://github.com/paoloose/urn";
    description = "Split tracker / timer for speedrunning with GTK+ frontend";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz ];
    mainProgram = "urn-gtk";
  };
}
