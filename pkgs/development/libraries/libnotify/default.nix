{ stdenv, fetchurl, pkgconfig, automake, autoconf, libtool, glib, gdk_pixbuf }:

stdenv.mkDerivation rec {
  ver_maj = "0.7";
  ver_min = "5";
  name = "libnotify-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/libnotify/${ver_maj}/${name}.tar.xz";
    sha256 = "0lmnzy16vdjs9vlgdm0b7wfyi1nh526hv2dpb7vxb92bhx3wny23";
  };
  src_m4 = fetchurl {
    url = "mirror://gentoo/distfiles/introspection-20110205.m4.tar.bz2";
    sha256 = "1cnqh7aaji648nfd5537v7xaak8hgww3bpifhwam7bl0sc3ad523";
  };

  # see Gentoo ebuild - we don't need to depend on gtk+(2/3)
  preConfigure = ''
    cd m4
    tar xvf ${src_m4}
    cd ..

    sed -i -e 's:noinst_PROG:check_PROG:' tests/Makefile.am || die
    sed -i -e '/PKG_CHECK_MODULES(TESTS/d' configure.ac || die
    AT_M4DIR=. autoreconf
  '';

  buildInputs = [ pkgconfig automake autoconf glib gdk_pixbuf ];

  meta = {
    homepage = http://galago-project.org/; # very obsolete but found no better
    description = "A library that sends desktop notifications to a notification daemon";
  };
}
