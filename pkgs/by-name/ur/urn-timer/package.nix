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
  version = "0-unstable-2025-04-17";

  src = fetchFromGitHub {
    owner = "paoloose";
    repo = "urn";
    rev = "5eea3f9efb03758bfafcd029406797d34e4c875b";
    hash = "sha256-rlUFZiA2fMa5QkKqKBRkiM8o2nioD0MPn6eJTJSJq3M=";
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
