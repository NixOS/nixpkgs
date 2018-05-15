{ fetchurl, stdenv, pkgconfig, intltool, gettext, glib, libxml2, zlib, bzip2
, python, perl, gdk_pixbuf, libiconv, libintl }:

let inherit (stdenv.lib) optionals; in

stdenv.mkDerivation rec {
  name = "libgsf-1.14.42";

  src = fetchurl {
    url    = "mirror://gnome/sources/libgsf/1.14/${name}.tar.xz";
    sha256 = "1hhdz0ymda26q6bl5ygickkgrh998lxqq4z9i8dzpcvqna3zpzr9";
  };

  nativeBuildInputs = [ pkgconfig intltool libintl ];

  buildInputs = [ gettext bzip2 zlib python ]
    ++ stdenv.lib.optional doCheck perl;

  propagatedBuildInputs = [ libxml2 glib gdk_pixbuf libiconv ];

  outputs = [ "out" "dev" ];

  doCheck = true;
  preCheck = "patchShebangs ./tests/";

  meta = with stdenv.lib; {
    description = "GNOME's Structured File Library";
    homepage    = https://www.gnome.org/projects/libgsf;
    license     = licenses.lgpl2Plus;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = stdenv.lib.platforms.unix;

    longDescription = ''
      Libgsf aims to provide an efficient extensible I/O abstraction for
      dealing with different structured file formats.
    '';
  };
}
