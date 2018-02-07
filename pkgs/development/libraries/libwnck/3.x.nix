{stdenv, fetchurl, pkgconfig, libX11, gtk3, intltool}:

stdenv.mkDerivation rec{
  name = "libwnck-${version}";
  version = "${majorVer}.${minorVer}.${patchVer}";

  majorVer = "3";
  minorVer = "24";
  patchVer = "1";

  src = fetchurl {
    url = "mirror://gnome/sources/libwnck/${majorVer}.${minorVer}/${name}.tar.xz";
    sha256 = "010zk9zvydggxqnxfml3scml5yxmpjy90irpqcayrzw26lldr9mg";
  };

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  patches = [ ./install_introspection_to_prefix.patch ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool ];
  propagatedBuildInputs = [ libX11 gtk3 ];

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
