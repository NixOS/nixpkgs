{ stdenv, fetchurl, pkgconfig, glib }:

let
  ver_maj = "0.8";
  ver_min = "6";
in
stdenv.mkDerivation rec {
  name = "libgee-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "https://download.gnome.org/sources/libgee/${ver_maj}/${name}.tar.xz";
    sha256 = "1mp3bfghc8qh2v8h2pfhksda22mgy2d5ygm1jr3bir544nr8i4fg";
  };

  buildInputs = [ glib ];
  nativeBuildInputs = [ pkgconfig ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Utility library providing GObject-based interfaces and classes for commonly used data structures";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    homepage = http://live.gnome.org/Libgee;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
