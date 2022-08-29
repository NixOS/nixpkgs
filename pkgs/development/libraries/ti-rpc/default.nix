{ fetchurl, lib, stdenv, autoreconfHook, libkrb5 }:

stdenv.mkDerivation rec {
  pname = "libtirpc";
  version = "1.3.3";

  src = fetchurl {
    url = "http://git.linux-nfs.org/?p=steved/libtirpc.git;a=snapshot;h=0fb94eef5062d2657d75eee686fa47238fafa312;sf=tgz";
    sha256 = "sha256-3P3xYKeAmLbBI4TdsG1VZBO7py9ktiwhXNtGsnryGNI=";
    name = "${pname}-${version}.tar.gz";
  };

  outputs = [ "out" "dev" ];

  postPatch = ''
    sed '1i#include <stdint.h>' -i src/xdr_sizeof.c
  '';

  KRB5_CONFIG = "${libkrb5.dev}/bin/krb5-config";
  nativeBuildInputs = [ autoreconfHook ];
  propagatedBuildInputs = [ libkrb5 ];

  preConfigure = ''
    sed -es"|/etc/netconfig|$out/etc/netconfig|g" -i doc/Makefile.in tirpc/netconfig.h
  '';

  preInstall = "mkdir -p $out/etc";

  doCheck = true;

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/libtirpc/";
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
