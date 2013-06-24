{ stdenv, fetchurl, pkgconfig, automake, autoconf, libtool, glib, gdk_pixbuf,
  gtk3, gobjectIntrospection }:

stdenv.mkDerivation rec {
  ver_maj = "0.7";
  ver_min = "5";
  name = "libnotify-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/libnotify/${ver_maj}/${name}.tar.xz";
    sha256 = "0lmnzy16vdjs9vlgdm0b7wfyi1nh526hv2dpb7vxb92bhx3wny23";
  };

  configureFlags = "--enable-introspection";

  preBuild = ''
    ln -s ${gdk_pixbuf + gdk_pixbuf.gir_path}/* .
  '';

  passthru = {
    gir_path = "/share/gir-1.0";
    gi_typelib_path = "/lib/girepository-1.0";
    gi_typelib_exports = [ gdk_pixbuf ];
  };

  buildInputs = [ pkgconfig automake autoconf glib gdk_pixbuf gtk3 gobjectIntrospection ];

  meta = {
    homepage = http://galago-project.org/; # very obsolete but found no better
    description = "A library that sends desktop notifications to a notification daemon";
  };
}
