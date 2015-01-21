{ stdenv, fetchurl, pkgconfig, glib, intltool, gnutls, libproxy
, gsettings_desktop_schemas }:

let
  ver_maj = "2.42";
  ver_min = "1";
in
stdenv.mkDerivation rec {
  name = "glib-networking-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/glib-networking/${ver_maj}/${name}.tar.xz";
    sha256 = "c06bf76da3353695fcc791b7b02e5d60c01c379e554f7841dc6cbca32f65f3a0";
  };

  configureFlags = "--with-ca-certificates=/etc/ssl/certs/ca-bundle.crt";

  preBuild = ''
    sed -e "s@${glib}/lib/gio/modules@$out/lib/gio/modules@g" -i $(find . -name Makefile)
  '';

  nativeBuildInputs = [ pkgconfig intltool ];
  propagatedBuildInputs = [ glib gnutls libproxy gsettings_desktop_schemas ];

  doCheck = false; # tests need to access the certificates (among other things)

  meta = with stdenv.lib; {
    description = "Network-related giomodules for glib";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
}

