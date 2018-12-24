{ stdenv, fetchurl, pkgconfig, intltool, gtk-doc, glib, avahi, gnutls, libuuid, libsoup, gtk3, gnome3 }:

let
  avahiWithGtk = avahi.override { gtk3Support = true; };
in stdenv.mkDerivation rec {
  pname = "libepc";
  version = "0.4.6";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1s3svb2slqjsrqfv50c2ymnqcijcxb5gnx6bfibwh9l5ga290n91";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    gtk-doc
  ];
  buildInputs = [
    glib
    libuuid
    gtk3
  ];
  propagatedBuildInputs = [
    avahiWithGtk
    gnutls
    libsoup
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Easy Publish and Consume Library";
    homepage = https://wiki.gnome.org/Projects/libepc;
    license = licenses.lgpl21Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
