{stdenv, fetchpatch, fetchurl, autoreconfHook, pkgconfig, atk, cairo, glib
, gnome-common, gtk, pango
, libxml2Python, perl, intltool, gettext, gtk-mac-integration }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "gtksourceview-${version}";
  version = "2.10.5";

  src = fetchurl {
    url = "mirror://gnome/sources/gtksourceview/2.10/${name}.tar.bz2";
    sha256 = "c585773743b1df8a04b1be7f7d90eecdf22681490d6810be54c81a7ae152191e";
  };

  patches = optionals stdenv.isDarwin [
    (fetchpatch {
      name = "change-igemacintegration-to-gtkosxapplication.patch";
      url = "https://git.gnome.org/browse/gtksourceview/patch/?id=e88357c5f210a8796104505c090fb6a04c213902";
      sha256 = "0h5q79q9dqbg46zcyay71xn1pm4aji925gjd5j93v4wqn41wj5m7";
    })
    (fetchpatch {
      name = "update-to-gtk-mac-integration-2.0-api.patch";
      url = "https://git.gnome.org/browse/gtksourceview/patch/?id=ab46e552e1d0dae73f72adac8d578e40bdadaf95";
      sha256 = "0qzrbv4hpa0v8qbmpi2vp575n13lkrvp3cgllwrd2pslw1v9q3aj";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    atk cairo glib gtk
    pango libxml2Python perl intltool
    gettext
  ] ++ optionals stdenv.isDarwin [
    autoreconfHook gnome-common gtk-mac-integration
  ];

  preConfigure = optionalString stdenv.isDarwin ''
    intltoolize --force
  '';
}
