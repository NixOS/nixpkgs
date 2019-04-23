{ stdenv, fetchurl, pkgconfig, meson, ninja, libusb, pixman, glib, nss, gtk3
, coreutils, gtk-doc, docbook_xsl, docbook_xml_dtd_43 }:

stdenv.mkDerivation rec {
  name = "libfprint-${version}";
  version = "0.99.0";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/libfprint/libfprint/uploads/82ba3cef5bdf72997df711eacdb13c0f/libfprint-${version}.tar.xz";
    sha256 = "16r4nl40y0jri57jiqmdz4s87byblx22lbhyvqpljd6mqm5rg187";
  };

  buildInputs = [ libusb pixman glib nss gtk3 ];
  nativeBuildInputs = [ pkgconfig meson ninja gtk-doc docbook_xsl docbook_xml_dtd_43 ];

  mesonFlags = [ "-Dudev_rules_dir=lib/udev/rules.d" "-Dx11-examples=false" ];

  preConfigure = ''
    substituteInPlace libfprint/meson.build \
      --replace /bin/echo ${coreutils}/bin/echo
  '';

  meta = with stdenv.lib; {
    homepage = https://fprint.freedesktop.org/;
    description = "A library designed to make it easy to add support for consumer fingerprint readers";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
