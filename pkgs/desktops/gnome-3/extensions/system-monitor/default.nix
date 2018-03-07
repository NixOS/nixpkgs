# This package needs the following configuration in configuration.nix:
# services.xserver.desktopManager.gnome3.sessionPath = [ pkgs.libgtop pkgs.glib_networking ];
{ config, stdenv, fetchFromGitHub, glib, glib_networking, libgtop, pkgs }:

stdenv.mkDerivation rec {
  name = "gnome-shell-system-monitor-${version}";
  version = "v33";

  src = fetchFromGitHub {
    owner = "paradoxxxzero";
    repo = "gnome-shell-system-monitor-applet";
    rev = version;
    sha256 = "0abqaanl5r26x8f0mm0jgrjsr86hcx7mk75dx5c3zz7csw4nclkk";
  };

  buildInputs = [
    glib
    glib_networking
    libgtop
  ];

  patches = [ ./remove_nonexisting_mounts.patch ];

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
