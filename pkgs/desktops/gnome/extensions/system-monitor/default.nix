{ lib, stdenv, substituteAll, fetchFromGitHub, glib, glib-networking, libgtop, gnome }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-system-monitor";
  version = "unstable-2022-02-04";

  src = fetchFromGitHub {
    owner = "paradoxxxzero";
    repo = "gnome-shell-system-monitor-applet";
    rev = "2c6eb0a447bfc9f1a07c61956c92a55c874baf16";
    hash = "sha256-JuRRlvqlqneqUdgezKGl2yg7wFYGCCo51q9CBwrxTBY=";
  };

  nativeBuildInputs = [
    glib
    gnome.gnome-shell
  ];

  patches = [
    (substituteAll {
      src = ./paths_and_nonexisting_dirs.patch;
      clutter_path = gnome.mutter.libdir; # only needed for GNOME < 40.
      gtop_path = "${libgtop}/lib/girepository-1.0";
      glib_net_path = "${glib-networking}/lib/girepository-1.0";
    })
  ];

  makeFlags = [
    "VERSION=${version}"
    "INSTALLBASE=$(out)/share/gnome-shell/extensions"
    "SUDO="
  ];

  passthru = {
    extensionUuid = "system-monitor@paradoxxx.zero.gmail.com";
    extensionPortalSlug = "system-monitor";
  };

  meta = with lib; {
    description = "Display system informations in gnome shell status bar";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ andersk ];
    homepage = "https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet";
  };
}
