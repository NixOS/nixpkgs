{ fetchurl, stdenv, pkgconfig, intltool, gettext, glib, libxml2, zlib, bzip2
, python, perl, gdk_pixbuf, libiconv, libintlOrEmpty }:

let inherit (stdenv.lib) optionals; in

stdenv.mkDerivation rec {
  name = "libgsf-1.14.41";

  src = fetchurl {
    url    = "mirror://gnome/sources/libgsf/1.14/${name}.tar.xz";
    sha256 = "1lq87wnrsjbjafpk3c8xwd56gqx319fhck9xkg2da88hd9c9h2qm";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [ gettext bzip2 zlib python ]
    ++ stdenv.lib.optional doCheck perl;

  propagatedBuildInputs = [ libxml2 glib gdk_pixbuf libiconv ]
    ++ libintlOrEmpty;

  outputs = [ "out" "dev" ];

  doCheck = true;
  preCheck = "patchShebangs ./tests/";

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-lintl";

  meta = with stdenv.lib; {
    description = "GNOME's Structured File Library";
    homepage    = http://www.gnome.org/projects/libgsf;
    license     = licenses.lgpl2Plus;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = stdenv.lib.platforms.unix;

    longDescription = ''
      Libgsf aims to provide an efficient extensible I/O abstraction for
      dealing with different structured file formats.
    '';
  };
}
