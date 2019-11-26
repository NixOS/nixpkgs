{ autoreconfHook, cinnamon-desktop, fetchFromGitHub, glib, gnome3, gnome-doc-utils, gobjectIntrospection, gtk3, intltool, json-glib, libinput, libstartup_notification, libxkbcommon, libXtst, pkgconfig, stdenv, udev, xorg }:

stdenv.mkDerivation rec {
  pname = "muffin";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "muffin";
    rev = "${version}";
    sha256 = "07z36hir0kahifmvv3kpjb7bbjz1xwkp7rgrzl84fj5bgczsydf6";
  };

  patches = [ ./disable-docs.patch ];

  buildInputs = [ cinnamon-desktop glib gobjectIntrospection gtk3 gnome3.zenity gnome-doc-utils intltool json-glib libinput libstartup_notification libxkbcommon libXtst pkgconfig udev xorg.xkeyboardconfig xorg.libxkbfile ];
  nativeBuildInputs = [ autoreconfHook ];
}
