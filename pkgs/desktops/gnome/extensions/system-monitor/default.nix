{ lib, stdenv, substituteAll, fetchFromGitHub, glib, libgtop, gnome }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-system-monitor";
  version = "unstable-2023-11-20";

  # Sourced from fork pending paradoxxxzero/gnome-shell-system-monitor-applet#767
  src = fetchFromGitHub {
    owner = "mgalgs";
    repo = "gnome-shell-system-monitor-applet";
    rev = "5827e7960f9891bdaa53f0663ea5135423ff8b18";
    hash = "sha256-mw5YfQcZYY3FijekV0xMDSDXG5t0SemPIkACng6NMPo=";
  };

  nativeBuildInputs = [
    glib
    gnome.gnome-shell
  ];

  patches = [
    (substituteAll {
      src = ./paths_and_nonexisting_dirs.patch;
      gtop_path = "${libgtop}/lib/girepository-1.0";
    })
  ];

  makeFlags = [
    "VERSION=${version}"
    "INSTALLBASE=$(out)/share/gnome-shell/extensions"
    "SUDO="
  ];

  passthru = {
    extensionUuid = "system-monitor-next@paradoxxx.zero.gmail.com";
    extensionPortalSlug = "system-monitor-next";
  };

  meta = with lib; {
    description = "Display system informations in gnome shell status bar";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ andersk ];
    homepage = "https://github.com/mgalgs/gnome-shell-system-monitor-applet";
  };
}
