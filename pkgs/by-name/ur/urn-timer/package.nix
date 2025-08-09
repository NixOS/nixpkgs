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
  version = "0-unstable-2025-07-21";

  src = fetchFromGitHub {
    owner = "paoloose";
    repo = "urn";
    rev = "3e5d00cfb19c27e155e6bb03a11a70f1e89b0842";
    hash = "sha256-FttQ9NffJQ8UjNaRUQ6kCDnDHp72q8eOmIhnoplwtYw=";
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
