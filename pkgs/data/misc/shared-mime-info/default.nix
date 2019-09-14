{stdenv, fetchurl, pkgconfig, gettext, perlPackages, intltool
, libxml2, glib, itstool }:

let version = "1.13.1"; in
stdenv.mkDerivation {
  pname = "shared-mime-info";
  inherit version;

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/xdg/shared-mime-info/uploads/5349e18c86eb96eee258a5c1f19122d0/shared-mime-info-1.13.1.tar.xz";
    sha256 = "1bic8z5nz08qxv1x6zlxnx2j4cmlzm12kygrn3rrh1djqxdhma3f";
  };

  nativeBuildInputs = [ pkgconfig gettext intltool ] ++ (with perlPackages; [ perl XMLParser ]);
  buildInputs = [ libxml2 glib itstool ];

  meta = with stdenv.lib; {
    inherit version;
    description = "A database of common MIME types";
    homepage = http://freedesktop.org/wiki/Software/shared-mime-info;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimame ];
  };
}
