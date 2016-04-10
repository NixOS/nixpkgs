{stdenv, fetchurl, pkgconfig, libX11, gtk3, intltool}:

stdenv.mkDerivation {
  name = "libwnck-3.4.7";

  src = fetchurl {
    url = mirror://gnome/sources/libwnck/3.4/libwnck-3.4.7.tar.xz;
    sha256 = "d48ac9c7f50c0d563097f63d07bcc83744c7d92a1b4ef65e5faeab32b5ccb723";
  };

  outputs = [ "dev" "out" "docdev" ];
  outputBin = "dev";

  patches = [ ./install_introspection_to_prefix.patch ];

  buildInputs = [ pkgconfig intltool ];
  propagatedBuildInputs = [ libX11 gtk3 ];
}
