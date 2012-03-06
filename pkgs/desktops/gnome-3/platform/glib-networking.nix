{ stdenv, fetchurl, glib, pkgconfig, intltool, gnutls, libgcrypt
, gsettings_desktop_schemas }:

stdenv.mkDerivation {
  name = "glib-networking-2.30.2";

  src = fetchurl {
    url = mirror://gnome/sources/glib-networking/2.30/glib-networking-2.30.2.tar.xz;
    sha256 = "1g2ran0rn37009fs3xl38m95i5w8sdf9ax0ady4jbjir15844xcz";
  };

  propagatedBuildInputs = [ glib gnutls libgcrypt ];
  buildInputs = [ gsettings_desktop_schemas ];
  buildNativeInputs = [ pkgconfig intltool ];

  configureFlags = "--without-ca-certificates";
  postConfigure = "export makeFlags=GIO_MODULE_DIR=$out/${glib.gioModuleDir}";

  meta = {
    TODO = "Look at `--without-ca-certificates` again";
    inherit (glib.meta) platforms maintainers;
  };
}
