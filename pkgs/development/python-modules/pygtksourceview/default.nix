{ stdenv, fetchurl, python, pkgconfig, pygobject, glib, pygtk, gnome2 }:

let version = "2.10.1"; in

stdenv.mkDerivation {
  name = "pygtksourceview-${version}";

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/gnome/sources/pygtksourceview/2.10/pygtksourceview-${version}.tar.bz2";
    sha256 = "0x2r9k547ad68sfddr5am341ap6zvy8k0rh3rd0n38k7xdd7rd5l";
  };

  patches = [ ./codegendir.patch ];

  buildInputs = [ python pkgconfig pygobject glib pygtk gnome2.gtksourceview ];
}
