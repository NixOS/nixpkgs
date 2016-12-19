{ stdenv, fetchurl, pkgconfig, automake, autoconf, libtool
, glib, gdk_pixbuf, gobjectIntrospection, autoreconfHook }:

stdenv.mkDerivation rec {
  ver_maj = "0.7";
  ver_min = "6";
  name = "libnotify-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/libnotify/${ver_maj}/${name}.tar.xz";
    sha256 = "0dyq8zgjnnzcah31axnx6afb21kl7bks1gvrg4hjh3nk02j1rxhf";
  };

  # see Gentoo ebuild - we don't need to depend on gtk+(2/3)
  preAutoreconf = ''
    sed -i -e 's:noinst_PROG:check_PROG:' tests/Makefile.am || die
    sed -i -e '/PKG_CHECK_MODULES(TESTS/d' configure.ac || die
  '';

  buildInputs = [ pkgconfig automake autoconf autoreconfHook
                  libtool glib gdk_pixbuf gobjectIntrospection ];

  meta = {
    homepage = http://galago-project.org/; # very obsolete but found no better
    description = "A library that sends desktop notifications to a notification daemon";
    platforms = stdenv.lib.platforms.unix;
  };
}
