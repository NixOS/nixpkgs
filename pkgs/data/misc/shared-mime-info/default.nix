{ stdenv
, fetchurl
, pkgconfig
, gettext
, perlPackages
, itstool
, libxml2
, glib
}:

stdenv.mkDerivation rec {
  pname = "shared-mime-info";
  version = "1.13.1";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/xdg/${pname}/uploads/5349e18c86eb96eee258a5c1f19122d0/${pname}-${version}.tar.xz";
    sha256 = "1bic8z5nz08qxv1x6zlxnx2j4cmlzm12kygrn3rrh1djqxdhma3f";
  };

  nativeBuildInputs = [
    pkgconfig
    gettext
    itstool
  ] ++ (with perlPackages; [
    perl XMLParser
  ]);

  buildInputs = [
    libxml2
    glib
  ];

  meta = with stdenv.lib; {
    description = "A database of common MIME types";
    homepage = http://freedesktop.org/wiki/Software/shared-mime-info;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimame ];
  };
}
