{ stdenv, fetchurl, pkgconfig, glib, intltool, gnutls, libproxy
, gsettings_desktop_schemas }:

let
  ver_maj = "2.46";
  ver_min = "1";
in
stdenv.mkDerivation rec {
  name = "glib-networking-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/glib-networking/${ver_maj}/${name}.tar.xz";
    sha256 = "1cchmi08jpjypgmm9i7xzh5qfg2q5k61kry9ns8mhw3z44a440ym";
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

