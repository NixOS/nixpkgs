{ stdenv, fetchurl, which, pkgconfig, mono }:

stdenv.mkDerivation rec {
  name = "mono-zeroconf-${version}";
  version = "0.9.0";

  src = fetchurl {
    url = "http://download.banshee-project.org/mono-zeroconf/mono-zeroconf-${version}.tar.bz2";
    sha256 = "1qfp4qvsx7rc2shj1chi2y7fxn10rwi70rw2y54b2i8a4jq7gpkb";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ which mono ];

  dontStrip = true;

  configureFlags = [ "--disable-docs" ];

  meta = with stdenv.lib; {
    description = "A cross platform Zero Configuration Networking library for Mono and .NET";
    homepage = https://www.mono-project.com/archived/monozeroconf/;
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
