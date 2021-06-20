{ lib, stdenv, fetchzip, autoconf, automake, libtool, libpcap }:

stdenv.mkDerivation rec {
  pname = "libcrafter";
  version = "1.0";

  src = fetchzip {
    url = "https://github.com/pellegre/libcrafter/archive/version-${version}.zip";
    sha256 = "1d2vgxawdwk2zg3scxclxdby1rhghmivly8azdjja89kw7gls9xl";
  };

  preConfigure = "cd libcrafter";

  configureScript = "./autogen.sh";

  configureFlags = [ "--with-libpcap=yes" ];

  buildInputs = [ autoconf automake libtool ];

  propagatedBuildInputs = [ libpcap ];

  meta = {
    homepage = "https://github.com/pellegre/libcrafter";
    description = "High level C++ network packet sniffing and crafting library";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
