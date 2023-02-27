{ lib, stdenv, substituteAll, fetchFromGitHub, fetchpatch, glib, glib-networking, libgtop, gnome }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-system-monitor";
  version = "unstable-2022-04-25";

  src = fetchFromGitHub {
    owner = "paradoxxxzero";
    repo = "gnome-shell-system-monitor-applet";
    rev = "b359d888fd3fcccf1252f5f1dc390299e701493e";
    hash = "sha256-FHErXetGN4n0TbrLQ5cN7V2IgO96ekHxiHLd0diRFAY=";
  };

  nativeBuildInputs = [
    glib
    gnome.gnome-shell
  ];

  patches = [
    # GNOME 43 compatibility
    (fetchpatch {
      url = "https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet/pull/754/commits/3b3a617f78c5e9bbce0aa2864b3989335edb37b7.patch";
      hash = "sha256-BAD0ExQYmTg6i02Gg7jcF0vf1zp232vXRjGCn+rBYXE=";
    })
    (fetchpatch {
      url = "https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet/pull/754/commits/0815ed9da5056542730838fbf6c600506cf7a76f.patch";
      hash = "sha256-pavjlPV9BxXoqb0YrlP2bXT7tkNQaBkTy1pMrI9MLnk=";
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
