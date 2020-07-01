{ fetchurl, stdenv, pkgconfig, intltool, gettext, glib, libxml2, zlib, bzip2
, perl, gdk-pixbuf, libiconv, libintl, gnome3 }:

stdenv.mkDerivation rec {
  pname = "libgsf";
  version = "1.14.47";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0kbpp9ksl7977xiga37sk1gdw1r039v6zviqznl7alvvg39yp26i";
  };

  nativeBuildInputs = [ pkgconfig intltool libintl ];

  buildInputs = [ gettext bzip2 zlib ];
  checkInputs = [ perl ];

  propagatedBuildInputs = [ libxml2 glib gdk-pixbuf libiconv ];

  outputs = [ "out" "dev" ];

  doCheck = true;
  preCheck = "patchShebangs ./tests/";

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "GNOME's Structured File Library";
    homepage    = "https://www.gnome.org/projects/libgsf";
    license     = licenses.lgpl2Plus;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = stdenv.lib.platforms.unix;

    longDescription = ''
      Libgsf aims to provide an efficient extensible I/O abstraction for
      dealing with different structured file formats.
    '';
  };
}
