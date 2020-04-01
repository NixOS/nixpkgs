{ fetchurl, stdenv, autoreconfHook, libkrb5 }:

stdenv.mkDerivation rec {
  name = "libtirpc-1.2.5";

  src = fetchurl {
    url = "mirror://sourceforge/libtirpc/${name}.tar.bz2";
    sha256 = "1jl6a5kkw2vrp4gb6pmvf72rqimywvwfb9f7iz2xjg4wgq63bdpk";
  };

  outputs = [ "out" "dev" ];

  postPatch = ''
    sed '1i#include <stdint.h>' -i src/xdr_sizeof.c
  '' + stdenv.lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace tirpc/rpc/types.h \
      --replace '#if defined __APPLE_CC__ || defined __FreeBSD__' \
                '#if defined __APPLE_CC__ || defined __FreeBSD__ || !defined __GLIBC__'
  '';

  KRB5_CONFIG = "${libkrb5.dev}/bin/krb5-config";
  nativeBuildInputs = [ autoreconfHook ];
  propagatedBuildInputs = [ libkrb5 ];

  preConfigure = ''
    sed -es"|/etc/netconfig|$out/etc/netconfig|g" -i doc/Makefile.in tirpc/netconfig.h
  '';

  preInstall = "mkdir -p $out/etc";

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/projects/libtirpc/;
    description = "The transport-independent Sun RPC implementation (TI-RPC)";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
    longDescription = ''
       Currently, NFS commands use the SunRPC routines provided by the
       glibc.  These routines do not support IPv6 addresses.  Ulrich
       Drepper, who is the maintainer of the glibc, refuses any change in
       the glibc concerning the RPC.  He wants the RPC to become a separate
       library.  Other OS (NetBSD, FreeBSD, Solarix, HP-UX, AIX) have
       migrated their SunRPC library to a TI-RPC (Transport Independent
       RPC) implementation.  This implementation allows the support of
       other transports than UDP and TCP over IPv4.  FreeBSD provides a
       TI-RPC library ported from NetBSD with improvements.  This library
       already supports IPv6.  So, the FreeBSD release 5.2.1 TI-RPC has
       been ported to replace the SunRPC of the glibc.
    '';
  };
}
