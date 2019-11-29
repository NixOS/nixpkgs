{ lib, fetchurl, python, buildPythonPackage, pkgconfig, pygobject2, glib, pygtk, gnome2 }:

buildPythonPackage rec {
  pname = "pygtksourceview";
  format = "other";
  version = "2.10.1";

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/gnome/sources/pygtksourceview/2.10/pygtksourceview-${version}.tar.bz2";
    sha256 = "0x2r9k547ad68sfddr5am341ap6zvy8k0rh3rd0n38k7xdd7rd5l";
  };

  patches = [ ./codegendir.patch ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ python pygobject2 glib pygtk gnome2.gtksourceview ];

  meta = {
    platforms = lib.platforms.unix;
  };
}
