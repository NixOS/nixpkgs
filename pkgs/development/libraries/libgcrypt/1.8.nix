{ lib
, stdenv
, fetchurl
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
  version = "1.8.10";

  src = fetchurl {
    url = "mirror://gnupg/libgcrypt/libgcrypt-${version}.tar.bz2";
    sha256 = "sha256-aJaRVQH5UeI9AtywRTRpwswiqk13oAH/c6JkfC0p590=";
  };

  outputs = [ "out" "dev" "info" ];
  outputBin = "dev";

  # The CPU Jitter random number generator must not be compiled with
  # optimizations and the optimize -O0 pragma only works for gcc.
  # The build enables -O2 by default for everything else.
  hardeningDisable = lib.optional stdenv.cc.isClang "fortify";

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  buildInputs = [ libgpg-error ]
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

  doCheck = true;

  passthru.tests = {
    inherit gnupg libotr rsyslog;
  };

  meta = with lib; {
    homepage = "https://www.gnu.org/software/libgcrypt/";
    changelog = "https://git.gnupg.org/cgi-bin/gitweb.cgi?p=${pname}.git;a=blob;f=NEWS;hb=refs/tags/${pname}-${version}";
    description = "General-purpose cryptographic library";
    license = licenses.lgpl2Plus;
    platforms = platforms.all;
    knownVulnerabilities = [
      "CVE-2021-40528"
    ];
  };
}
