{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkgconfig, glib, gtk-doc, gtk, gobject-introspection }:

stdenv.mkDerivation rec {
  name = "gtk-mac-integration-2.0.8";

  src = fetchFromGitHub {
    owner = "GNOME";
    repo = "gtk-mac-integration";
    rev = "79e708870cdeea24ecdb036c77b4630104ae1776";
    sha256 = "1fbhnvj0rqc3089ypvgnpkp6ad2rr37v5qk38008dgamb9h7f3qs";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig gtk-doc gobject-introspection ];
  buildInputs = [ glib ];
  propagatedBuildInputs = [ gtk ];

  preAutoreconf = ''
    gtkdocize
  '';

  meta = with lib; {
    description = "Provides integration for Gtk+ applications into the Mac desktop";

    license = licenses.lgpl21;

    homepage = https://wiki.gnome.org/Projects/GTK+/OSX/Integration;

    maintainers = [ maintainers.matthewbauer ];
    platforms = platforms.darwin;
  };
}
