{lib, stdenv, fetchpatch, fetchurl, autoreconfHook, pkg-config, atk, cairo, glib
, gnome-common, gtk2, pango
, libxml2Python, perl, intltool, gettext, gtk-mac-integration-gtk2 }:

with lib;

stdenv.mkDerivation rec {
  pname = "gtksourceview";
  version = "2.10.5";

  src = fetchurl {
    url = "mirror://gnome/sources/gtksourceview/2.10/${pname}-${version}.tar.bz2";
    sha256 = "c585773743b1df8a04b1be7f7d90eecdf22681490d6810be54c81a7ae152191e";
  };

  patches = optionals stdenv.isDarwin [
    (fetchpatch {
      name = "change-igemacintegration-to-gtkosxapplication.patch";
      url = "https://gitlab.gnome.org/GNOME/gtksourceview/commit/e88357c5f210a8796104505c090fb6a04c213902.patch";
      sha256 = "0h5q79q9dqbg46zcyay71xn1pm4aji925gjd5j93v4wqn41wj5m7";
    })
    (fetchpatch {
      name = "update-to-gtk-mac-integration-2.0-api.patch";
      url = "https://gitlab.gnome.org/GNOME/gtksourceview/commit/ab46e552e1d0dae73f72adac8d578e40bdadaf95.patch";
      sha256 = "0qzrbv4hpa0v8qbmpi2vp575n13lkrvp3cgllwrd2pslw1v9q3aj";
    })
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    atk cairo glib gtk2
    pango libxml2Python perl intltool
    gettext
  ] ++ optionals stdenv.isDarwin [
    autoreconfHook gnome-common gtk-mac-integration-gtk2
  ];

  preConfigure = optionalString stdenv.isDarwin ''
    intltoolize --force
  '';

  doCheck = false; # requires X11 daemon
}
