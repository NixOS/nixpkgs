{stdenv, fetchurl, pkgconfig, gettext, perlPackages, intltool
, libxml2, glib}:

let version = "1.10"; in
stdenv.mkDerivation rec {
  name = "shared-mime-info-${version}";

  src = fetchurl {
    url = "http://freedesktop.org/~hadess/${name}.tar.xz";
    sha256 = "1gxyvwym3xgpmp262gfn8jg5sla6k5hy6m6dmy6grgiq90xsh9f6";
  };

  nativeBuildInputs = [ pkgconfig gettext intltool ] ++ (with perlPackages; [ perl XMLParser ]);
  buildInputs = [ libxml2 glib ];

  meta = with stdenv.lib; {
    inherit version;
    description = "A database of common MIME types";
    homepage = http://freedesktop.org/wiki/Software/shared-mime-info;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimadrid ];
  };
}
