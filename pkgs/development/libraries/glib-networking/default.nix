{ stdenv, fetchurl, pkgconfig, glib, intltool, gnutls, libproxy, gnome3
, gsettings-desktop-schemas }:

let
  pname = "glib-networking";
  version = "2.56.0";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "14vw8xwajd7m31bpavg2psk693plhjikwpk8bzf3jl1fmsy11za7";
  };

  outputs = [ "out" "dev" ]; # to deal with propagatedBuildInputs

  configureFlags = if stdenv.isDarwin then "--without-ca-certificates"
    else "--with-ca-certificates=/etc/ssl/certs/ca-certificates.crt";

  LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-lintl";

  preBuild = ''
    sed -e "s@${glib.out}/lib/gio/modules@$out/lib/gio/modules@g" -i $(find . -name Makefile)
  '';

  nativeBuildInputs = [ pkgconfig intltool ];
  propagatedBuildInputs = [ glib gnutls libproxy gsettings-desktop-schemas ];

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-lintl";

  doCheck = false; # tests need to access the certificates (among other things)

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Network-related giomodules for glib";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
}

