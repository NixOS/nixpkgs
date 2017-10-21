{ stdenv, fetchurl, pkgconfig, glib, gupnp }:
 
stdenv.mkDerivation rec {
  name = "gupnp-igd-${version}";
  majorVersion = "0.2";
  version = "${majorVersion}.4";

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp-igd/${majorVersion}/${name}.tar.xz";
    sha256 = "38c4a6d7718d17eac17df95a3a8c337677eda77e58978129ad3182d769c38e44";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib gupnp ];

  meta = {
    homepage = http://www.gupnp.org/;
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
  };
}

