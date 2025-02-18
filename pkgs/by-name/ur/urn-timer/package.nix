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
  version = "0-unstable-2025-02-02";

  src = fetchFromGitHub {
    owner = "paoloose";
    repo = "urn";
    rev = "124b411301f20d62b69832bbe1f7e6af2df85e9f";
    hash = "sha256-7mSuu2eebKWlMPOQAHBTYRxEEkpygrfKK7C1Ts8py6U=";
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
