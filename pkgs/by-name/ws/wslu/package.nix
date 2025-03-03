{
  lib,
  stdenv,
  fetchFromGitHub,
  copyDesktopItems,
}:

stdenv.mkDerivation rec {
  pname = "wslu";
  version = "4.1.4";

  src = fetchFromGitHub {
    owner = "wslutilities";
    repo = "wslu";
    rev = "v${version}";
    hash = "sha256-ssiwYkQg2rOirC/ZZVq2bJm4Ggc364uRkoS2y365Eb0=";
  };

  nativeBuildInputs = [ copyDesktopItems ];

  patches = [
    ./fallback-conf-nix-store.diff
  ];

  postPatch = ''
    substituteInPlace src/wslu-header \
      --subst-var out
    substituteInPlace src/etc/wslview.desktop \
      --replace-fail /usr/bin/wslview wslview
  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  meta = with lib; {
    description = "Collection of utilities for Windows Subsystem for Linux";
    homepage = "https://github.com/wslutilities/wslu";
    changelog = "https://github.com/wslutilities/wslu/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jamiemagee ];
    platforms = platforms.linux;
  };
}
