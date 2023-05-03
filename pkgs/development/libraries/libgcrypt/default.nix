{ lib
, stdenv
, fetchurl
, fetchpatch
, gettext
, libgpg-error
, enableCapabilities ? false, libcap
, buildPackages
# for passthru.tests
, gnupg
, libotr
, rsyslog
}:

assert enableCapabilities -> stdenv.isLinux;

stdenv.mkDerivation rec {
  pname = "libgcrypt";
  version = "1.10.2";

  src = fetchurl {
    url = "mirror://gnupg/libgcrypt/${pname}-${version}.tar.bz2";
    hash = "sha256-O5wCoAS2jCVq3ZlwHeALODrMzPNxd+DWxYKJZkzODAM=";
  };

  patches = lib.optionals (!stdenv.isLinux) [ # not everywhere to avoid rebuild for now
    (fetchpatch {
      name = "getrandom-conditionalize.patch";
      url = "https://git.gnupg.org/cgi-bin/gitweb.cgi?p=libgcrypt.git;a=commitdiff_plain;h=d41177937cea4aa1e9042ebcd195a349c40e8071";
      hash = "sha256-CgQjNtC1qLe5LicIc8rESc6Z1u4fk7ErMUVcG/2G9gM=";
    })
  ];

  outputs = [ "out" "dev" "info" ];
  outputBin = "dev";

  # The CPU Jitter random number generator must not be compiled with
  # optimizations and the optimize -O0 pragma only works for gcc.
  # The build enables -O2 by default for everything else.
  hardeningDisable = lib.optional stdenv.cc.isClang "fortify";

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  buildInputs = [ libgpg-error ]
    ++ lib.optional stdenv.isDarwin gettext
    ++ lib.optional enableCapabilities libcap;

  strictDeps = true;

  configureFlags = [ "--with-libgpg-error-prefix=${libgpg-error.dev}" ]
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
    sed -i 's,#include <gpg-error.h>,#include "${libgpg-error.dev}/include/gpg-error.h",g' "$dev/include/gcrypt.h"
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

  passthru.tests = {
    inherit gnupg libotr rsyslog;
  };

  meta = with lib; {
    homepage = "https://www.gnu.org/software/libgcrypt/";
    changelog = "https://git.gnupg.org/cgi-bin/gitweb.cgi?p=libgcrypt.git;a=blob;f=NEWS;hb=refs/tags/${pname}-${version}";
    description = "General-purpose cryptographic library";
    license = licenses.lgpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ vrthra ];
  };
}
