{ fetchurl, stdenv, pkgconfig, intltool, gettext, glib, libxml2, zlib, bzip2
, python, perl, gdk_pixbuf, libiconv, libintl, gnome3 }:

stdenv.mkDerivation rec {
  pname = "libgsf";
  version = "1.14.45";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1yk91ccf7z9b8d8ac6vip3gc5c0pkwgabqy6l0pj0kf43l7jrg2w";
  };

  nativeBuildInputs = [ pkgconfig intltool libintl ];

  buildInputs = [ gettext bzip2 zlib python ];
  checkInputs = [ perl ];

  propagatedBuildInputs = [ libxml2 glib gdk_pixbuf libiconv ];

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
