{ stdenv, fetchurl }:

let
  version = "0.2.2";
in
stdenv.mkDerivation {
  name = "libtirpc-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/libtirpc/libtirpc-${version}.tar.bz2";
    sha256 = "f05eb17c85d62423858b8f74512cfe66a9ae1cedf93f03c2a0a32e04f0a33705";
  };

  meta = {
    homepage = "http://sourceforge.net/projects/libtirpc/";
    description = "a port of Suns Transport-Independent RPC library to Linux";
    license = stdenv.lib.licenses.bsd3;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
