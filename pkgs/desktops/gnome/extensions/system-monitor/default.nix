{ lib, stdenv, substituteAll, fetchFromGitHub, fetchpatch, glib, glib-networking, libgtop, gnome }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-system-monitor";
  version = "unstable-2023-01-21";

  src = fetchFromGitHub {
    owner = "paradoxxxzero";
    repo = "gnome-shell-system-monitor-applet";
    rev = "21d7b4e7a03ec8145b0b90c4f0b15c27d6f53788";
    hash = "sha256-XDqWxTyaFEWPdXMTklcNQxqql73ESXAIF6TjMFHaj7g=";
  };

  nativeBuildInputs = [
    glib
    gnome.gnome-shell
  ];

  patches = [
    # GNOME 44 compatibility
    (fetchpatch {
      url = "https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet/pull/788/commits/e69349942791140807c01d472dfe5e0ddf5c73c0.patch";
      hash = "sha256-g5Ocpvp7eO/pBkDBZsxgXH7e8rdPBUUxDSwK2hJHKbY=";
    })
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
