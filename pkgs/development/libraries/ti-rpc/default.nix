{ fetchurl, fetchpatch, stdenv, autoreconfHook, libkrb5 }:

stdenv.mkDerivation rec {
  name = "libtirpc-1.0.3";

  src = fetchurl {
    url = "mirror://sourceforge/libtirpc/${name}.tar.bz2";
    sha256 = "0ppxl3k3nsz0qdakq844i2kj4fvh9h937lhx26bgmpmxq67sghw6";
  };

  patches = stdenv.lib.optional stdenv.hostPlatform.isMusl
    (fetchpatch {
      url = "https://raw.githubusercontent.com/openembedded/openembedded-core/2be873301420ec6ca2c70d899b7c49a7e2b0954d/meta/recipes-extended/libtirpc/libtirpc/0001-replace-__bzero-with-memset-API.patch";
      sha256 = "1jmbn0j2bnjp0j9z5vzz5xiwyv3kd28w5pixbqsy2lz6q8nii7cf";
    });

  postPatch = ''
    sed '1i#include <stdint.h>' -i src/xdr_sizeof.c
  '';

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
