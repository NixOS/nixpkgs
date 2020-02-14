{ stdenv, fetchurl, pkgconfig, dbus-glib, glib, ORBit2, libxml2, polkit, python3, intltool }:

stdenv.mkDerivation rec {
  pname = "gconf";
  version = "3.2.6";

  src = fetchurl {
    url = "mirror://gnome/sources/GConf/${stdenv.lib.versions.majorMinor version}/GConf-${version}.tar.xz";
    sha256 = "0k3q9nh53yhc9qxf1zaicz4sk8p3kzq4ndjdsgpaa2db0ccbj4hr";
  };

  outputs = [ "out" "dev" "man" ];

  buildInputs = [ ORBit2 libxml2 python3 ]
    # polkit requires pam, which requires shadow.h, which is not available on
    # darwin
    ++ stdenv.lib.optional (!stdenv.isDarwin) polkit;

  propagatedBuildInputs = [ glib dbus-glib ];

  nativeBuildInputs = [ pkgconfig intltool ];

  configureFlags =
    # fixes the "libgconfbackend-oldxml.so is not portable" error on darwin
    stdenv.lib.optional stdenv.isDarwin [ "--enable-static" ];

  postPatch = ''
    2to3 --write --nobackup gsettings/gsettings-schema-convert
  '';

  meta = with stdenv.lib; {
    homepage = https://projects.gnome.org/gconf/;
    description = "Deprecated system for storing application preferences";
    platforms = platforms.unix;
  };
}
