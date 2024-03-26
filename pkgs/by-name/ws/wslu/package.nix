{ lib
, stdenv
, fetchFromGitHub
, copyDesktopItems
}:

stdenv.mkDerivation rec {
  pname = "wslu";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "wslutilities";
    repo = "wslu";
    rev = "v${version}";
    hash = "sha256-rmNGKayg8Y872yICilveMpDFBLkDZ6Ox8rqtWrK2om8=";
  };

  nativeBuildInputs = [ copyDesktopItems ];

  patches = [
    ./fallback-conf-nix-store.diff
    ./fix-desktop-item.patch
  ];

  postPatch = ''
    substituteInPlace src/wslu-header \
      --subst-var out
  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  desktopItems = [ "src/etc/wslview.desktop" ];

  meta = with lib; {
    description = "A collection of utilities for Windows Subsystem for Linux";
    homepage = "https://github.com/wslutilities/wslu";
    changelog = "https://github.com/wslutilities/wslu/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jamiemagee ];
    platforms = platforms.linux;
  };
}
