{ stdenv, fetchurl, pkgconfig, glib, intltool, gnutls, libproxy
, gsettings_desktop_schemas }:

let
  ver_maj = "2.50";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "glib-networking-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/glib-networking/${ver_maj}/${name}.tar.xz";
    sha256 = "3f1a442f3c2a734946983532ce59ed49120319fdb10c938447c373d5e5286bee";
  };

  outputs = [ "out" "dev" ]; # to deal with propagatedBuildInputs

  configureFlags = "--with-ca-certificates=/etc/ssl/certs/ca-certificates.crt";

  preBuild = ''
    sed -e "s@${glib.out}/lib/gio/modules@$out/lib/gio/modules@g" -i $(find . -name Makefile)
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

