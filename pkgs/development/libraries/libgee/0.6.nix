{ stdenv, fetchurl, pkgconfig, glib }:

let
  ver_maj = "0.6";
  ver_min = "8";
in
stdenv.mkDerivation rec {
  name = "libgee-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "https://download.gnome.org/sources/libgee/${ver_maj}/${name}.tar.xz";
    sha256 = "1lzmxgz1bcs14ghfp8qqzarhn7s64ayx8c508ihizm3kc5wqs7x6";
  };

  buildInputs = [ glib ];
  nativeBuildInputs = [ pkgconfig ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Utility library providing GObject-based interfaces and classes for commonly used data structures";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    homepage = http://live.gnome.org/Libgee;
    maintainers = with maintainers; [ abbradar ];
  };
}
