{ lib
, stdenv
, fetchurl
, gettext
, libgpg-error
, enableCapabilities ? false, libcap
, buildPackages
# for passthru.tests
, gnupg
, libotr
, rsyslog
}:

assert enableCapabilities -> stdenv.hostPlatform.isLinux;

stdenv.mkDerivation rec {
  pname = "libgcrypt";
  version = "1.10.3";

  src = fetchurl {
    url = "mirror://gnupg/libgcrypt/${pname}-${version}.tar.bz2";
    hash = "sha256-iwhwiXrFrGfe1Wjc+t9Flpz6imvrD9YK8qnq3Coycqo=";
  };

  outputs = [ "bin" "lib" "dev" "info" "out" ];

  # The CPU Jitter random number generator must not be compiled with
  # optimizations and the optimize -O0 pragma only works for gcc.
  # The build enables -O2 by default for everything else.
  hardeningDisable = lib.optional stdenv.cc.isClang "fortify";

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  buildInputs = [ libgpg-error ]
    ++ lib.optional stdenv.hostPlatform.isDarwin gettext
    ++ lib.optional enableCapabilities libcap;

  strictDeps = true;

  configureFlags = [ "--with-libgpg-error-prefix=${libgpg-error.dev}" ]
      ++ lib.optional (stdenv.hostPlatform.isMusl || (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64)) "--disable-asm" # for darwin see https://dev.gnupg.org/T5157
      # Fix undefined reference errors with version script under LLVM.
      ++ lib.optional (stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17") "LDFLAGS=-Wl,--undefined-version";

  # Necessary to generate correct assembly when compiling for aarch32 on
  # aarch64
  configurePlatforms = [ "host" "build" ];

  postConfigure = ''
    sed -i configure \
        -e 's/NOEXECSTACK_FLAGS=$/NOEXECSTACK_FLAGS="-Wa,--noexecstack"/'
  '';

  enableParallelBuilding = true;

  # Make sure libraries are correct for .pc and .la files
  # Also make sure includes are fixed for callers who don't use libgpgcrypt-config
  postFixup = ''
    sed -i 's,#include <gpg-error.h>,#include "${libgpg-error.dev}/include/gpg-error.h",g' "$dev/include/gcrypt.h"
  ''
  # The `libgcrypt-config` script references $dev and in the $dev output, the
  # stdenv automagically puts the $bin output into propagatedBuildInputs. This
  # would cause a cycle. This is a weird tool anyways, so let's stuff it in $dev
  # instead.
  + ''
    moveToOutput bin/libgcrypt-config $dev
  '' + lib.optionalString enableCapabilities ''
    sed -i 's,\(-lcap\),-L${libcap.lib}/lib \1,' $lib/lib/libgcrypt.la
  '';

  # TODO: figure out why this is even necessary and why the missing dylib only crashes
  # random instead of every test
  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $lib/lib
    cp src/.libs/libgcrypt.20.dylib $lib/lib
  '';

  doCheck = true;
  enableParallelChecking = true;

  passthru.tests = {
    inherit gnupg libotr rsyslog;
  };

  meta = with lib; {
    homepage = "https://www.gnu.org/software/libgcrypt/";
    changelog = "https://git.gnupg.org/cgi-bin/gitweb.cgi?p=${pname}.git;a=blob;f=NEWS;hb=refs/tags/${pname}-${version}";
    description = "General-purpose cryptographic library";
    license = licenses.lgpl2Plus;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
