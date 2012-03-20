{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "libtirpc-0.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/libtirpc/${name}.tar.bz2";
    sha256 = "f05eb17c85d62423858b8f74512cfe66a9ae1cedf93f03c2a0a32e04f0a33705";
  };

  # http://www.sourcemage.org/projects/grimoire/repository/revisions/d6344b6a3a94b88ed67925a474de5930803acfbf
  preConfigure = ''
    echo "" > src/des_crypt.c

    sed -es"|/etc/netconfig|$out/etc/netconfig|g" -i "doc/Makefile.in"
  '';

  preInstall = "mkdir -p $out/etc";

  doCheck = true;

  meta = {
    homepage = "http://sourceforge.net/projects/libtirpc/";
    description = "The transport-independent Sun RPC implementation (TI-RPC)";
    license = stdenv.lib.licenses.bsd3;
    longDescription = ''
       Currently, NFS commands use the SunRPC routines provided by the
       glibc.  These routines do not support IPv6 addresses.  Ulrich
       Drepper, who is the maintainer of the glibc, refuses any change in
       the glibc concerning the RPC.  He wants the RPC to become a separate
       library.  Other OS (NetBSD, FreeBSD, Solarix, HP-UX, AIX) have
       migrated their SunRPC library to a TI-RPC (Transport Independent
       RPC) implementation.  This implementation allows the support of
       other transports than UDP and TCP over IPv4.  FreeBSD provides a
       TI-RPC library ported from NetBSD with improvments.  This library
       already supports IPv6.  So, the FreeBSD release 5.2.1 TI-RPC has
       been ported to replace the SunRPC of the glibc.
    '';

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.ludo stdenv.lib.maintainers.simons ];
  };
}
