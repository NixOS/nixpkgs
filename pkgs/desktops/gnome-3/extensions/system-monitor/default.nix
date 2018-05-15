{ config, stdenv, substituteAll, fetchFromGitHub, glib, glib_networking, libgtop, pkgs }:

stdenv.mkDerivation rec {
  name = "gnome-shell-system-monitor-${version}";
  version = "33";

  src = fetchFromGitHub {
    owner = "paradoxxxzero";
    repo = "gnome-shell-system-monitor-applet";
    rev = "v${version}";
    sha256 = "0abqaanl5r26x8f0mm0jgrjsr86hcx7mk75dx5c3zz7csw4nclkk";
  };

  buildInputs = [
    glib
    glib_networking
    libgtop
  ];

  patches = [
    (substituteAll {
      src = ./paths_and_nonexisting_dirs.patch;
      gtop_path = "${libgtop}/lib/girepository-1.0";
      glib_net_path = "${glib_networking}/lib/girepository-1.0";
    })
  ];

  buildPhase = ''
    ${glib.dev}/bin/glib-compile-schemas --targetdir=${uuid}/schemas ${uuid}/schemas
  '';

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions
  '';

  uuid = "system-monitor@paradoxxx.zero.gmail.com";

  meta = with stdenv.lib; {
    description = "Display system informations in gnome shell status bar";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aneeshusa tiramiseb ];
    homepage = https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet;
  };
}
