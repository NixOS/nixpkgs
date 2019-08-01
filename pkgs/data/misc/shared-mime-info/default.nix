{stdenv, fetchurl, pkgconfig, gettext, perlPackages, intltool
, libxml2, glib}:

let version = "1.12"; in
stdenv.mkDerivation rec {
  name = "shared-mime-info-${version}";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/xdg/shared-mime-info/uploads/80c7f1afbcad2769f38aeb9ba6317a51/shared-mime-info-1.12.tar.xz";
    sha256 = "0gj0pp36qpsr9w6v4nywnjpcisadwkndapqsjn0ny3gd0zzg1chq";
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
