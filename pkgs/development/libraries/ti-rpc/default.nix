{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "libtirpc-0.1.8-1";

  src = fetchurl {
    url = "http://nfsv4.bullopensource.org/tarballs/tirpc/${name}.tar.bz2";
    sha256 = "0jf0sj2cv1rm1dm1i226ww9h93srljf8zf0yfy9mvwxg8gqnn5fy";
  };

  preConfigure =
    '' sed -es"|/etc/netconfig|$out/etc/netconfig|g" -i "Makefile.in"
    '';
  preInstall = "ensureDir $out/etc";

  doCheck = true;

  meta = {
    description = "The transport-independent Sun RPC implementation (TI-RPC)";

    longDescription =
      '' Currently, NFS commands use the SunRPC routines provided by the
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

    homepage = http://nfsv4.bullopensource.org/doc/tirpc_rpcbind.php;

    # Free software license, see
    # <http://www.gnu.org/licenses/license-list.html#SISSL>.
    license = "Sun Industry Standards Source License 1.0";

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
