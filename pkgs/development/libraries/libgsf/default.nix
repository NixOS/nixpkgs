{ fetchurl, stdenv, pkgconfig, intltool, gettext, glib, libxml2, zlib, bzip2
, python
}:

with { inherit (stdenv.lib) optionals; };

stdenv.mkDerivation rec {
  name = "libgsf-1.14.25";

  src = fetchurl {
    url = "mirror://gnome/sources/libgsf/1.14/${name}.tar.xz";
    sha256 = "18ni8hwi3q83vs3m6mg6xwd4g7jvss4kz70kzf21k587gvq4hx8j";
  };

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs = [ gettext bzip2 zlib python ];

  propagatedBuildInputs = [ libxml2 glib ];

  doCheck = true;

  meta = {
    homepage = http://www.gnome.org/projects/libgsf;
    license = "LGPLv2";
    description = "GNOME's Structured File Library";

    longDescription = ''
      Libgsf aims to provide an efficient extensible I/O abstraction for
      dealing with different structured file formats.
    '';

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.linux;
  };
}
