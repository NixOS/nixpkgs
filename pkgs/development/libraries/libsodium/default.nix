{ stdenv, fetchurl, autoconf, libtool, automake }:

let
  version = "0.4.3";
in
stdenv.mkDerivation rec {
  name = "libsodium-${version}";

  src = fetchurl {
    url = "https://github.com/jedisct1/libsodium/tarball/${version}";
    name = "${name}.tar.gz";
    sha256 = "0vammhvkz6masnwyacqkzkah05bgv3syb97jvg2y49vb67pwmspn";
  };

  preConfigure = ''
    ACLOCAL_PATH=$ACLOCAL_PATH:`pwd`/m4
    ./autogen.sh
  '';

  buildInputs = [ autoconf libtool automake ];

  doCheck = true;

  meta = {
    description = "Version of NaCl with harwdare tests at runtime, not build time";
    license = "ISC";
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = stdenv.lib.platforms.all;
  };
}
