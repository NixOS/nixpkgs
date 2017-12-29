{stdenv, fetchurl, pkgconfig, gettext, perl, perlXMLParser, intltool
, libxml2, glib}:

let version = "1.9"; in
stdenv.mkDerivation rec {
  name = "shared-mime-info-${version}";

  src = fetchurl {
    url = "http://freedesktop.org/~hadess/${name}.tar.xz";
    sha256 = "10ywzhzg8v1xmb9sz5xbqaci90id38knswigynyl33i29vn360aw";
  };

  nativeBuildInputs = [
    pkgconfig gettext intltool perl perlXMLParser libxml2 glib
  ];

  meta = with stdenv.lib; {
    inherit version;
    description = "A database of common MIME types";
    homepage = http://freedesktop.org/wiki/Software/shared-mime-info;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimadrid ];
  };
}
