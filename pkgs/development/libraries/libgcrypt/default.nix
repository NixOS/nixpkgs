{ lib, stdenv, fetchurl, fetchpatch, gettext, libgpgerror, enableCapabilities ? false, libcap, buildPackages }:

assert enableCapabilities -> stdenv.isLinux;

stdenv.mkDerivation rec {
  pname = "libgcrypt";
  version = "1.9.2";

  src = fetchurl {
    url = "mirror://gnupg/libgcrypt/${pname}-${version}.tar.bz2";
    sha256 = "sha256-ssENCRUTsnHkcXcnRgex/7o9lbGIu/qHl/lIrskFPFo=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2021-33560.patch";
      url = "https://git.gnupg.org/cgi-bin/gitweb.cgi?p=libgcrypt.git;a=blobdiff_plain;f=cipher/elgamal.c;h=eead45022abc9d367563f065071afbbf9b5e3e55;hp=9835122fb18c615f58ad1ea580682dfb48970bf1;hb=3462280f2e23e16adf3ed5176e0f2413d8861320;hpb=8d3db6add149696bd777c6969442d771e9efdecf";
      sha256 = "01kxy41bddhphizjyha5nwh9k6np7s4b1cfljxgwywc5hvdsz0zx";
    })
  ];

  outputs = [ "out" "dev" "info" ];
  outputBin = "dev";

  # The CPU Jitter random number generator must not be compiled with
  # optimizations and the optimize -O0 pragma only works for gcc.
  # The build enables -O2 by default for everything else.
  hardeningDisable = lib.optional stdenv.cc.isClang "fortify";

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  buildInputs = [ libgpgerror ]
    ++ lib.optional stdenv.isDarwin gettext
    ++ lib.optional enableCapabilities libcap;

  strictDeps = true;

  configureFlags = [ "--with-libgpg-error-prefix=${libgpgerror.dev}" ]
      ++ lib.optional (stdenv.hostPlatform.isMusl || (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64)) "--disable-asm"; # for darwin see https://dev.gnupg.org/T5157

  # Necessary to generate correct assembly when compiling for aarch32 on
  # aarch64
  configurePlatforms = [ "host" "build" ];

  postConfigure = ''
    sed -i configure \
        -e 's/NOEXECSTACK_FLAGS=$/NOEXECSTACK_FLAGS="-Wa,--noexecstack"/'
  '';

  # Make sure libraries are correct for .pc and .la files
  # Also make sure includes are fixed for callers who don't use libgpgcrypt-config
  postFixup = ''
    sed -i 's,#include <gpg-error.h>,#include "${libgpgerror.dev}/include/gpg-error.h",g' "$dev/include/gcrypt.h"
  '' + lib.optionalString enableCapabilities ''
    sed -i 's,\(-lcap\),-L${libcap.lib}/lib \1,' $out/lib/libgcrypt.la
  '';

  # TODO: figure out why this is even necessary and why the missing dylib only crashes
  # random instead of every test
  preCheck = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/lib
    cp src/.libs/libgcrypt.20.dylib $out/lib
  '';

  doCheck = true;

  meta = with lib; {
    homepage = "https://www.gnu.org/software/libgcrypt/";
    description = "General-purpose cryptographic library";
    license = licenses.lgpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ vrthra ];
    repositories.git = "git://git.gnupg.org/libgcrypt.git";
  };
}
