{ lib
, stdenv
, fetchurl
, withJitSealloc ? true
}:

stdenv.mkDerivation rec {
  pname = "pcre2";
  version = "10.43";

  src = fetchurl {
    url = "https://github.com/PhilipHazel/pcre2/releases/download/pcre2-${version}/pcre2-${version}.tar.bz2";
    hash = "sha256-4qU5hP8LB9/bWuRIa7ubIcyo598kNAlsyb8bcow1C8s=";
  };

  postPatch = ''
    # Fix jit autodetection:
    #   https://github.com/PCRE2Project/pcre2/pull/396
    # Applying manually to avoid fetchpatch and autoreconfHook.
    # TODO: remove once 10.44 is released
    substituteInPlace configure --replace-fail \
      '#include "src/sljit/sljitConfigInternal.h"' \
      '#include "src/sljit/sljitConfigCPU.h"'
  '';

  configureFlags = [
    "--enable-pcre2-16"
    "--enable-pcre2-32"
    # only enable jit on supported platforms which excludes Apple Silicon, see https://github.com/zherczeg/sljit/issues/51
    "--enable-jit=${if stdenv.hostPlatform.isS390x || stdenv.hostPlatform.isLoongArch64 then "no" else "auto"}"
  ]
  # fix pcre jit in systemd units that set MemoryDenyWriteExecute=true like gitea
  ++ lib.optional withJitSealloc "--enable-jit-sealloc";

  outputs = [ "bin" "dev" "out" "doc" "man" "devdoc" ];

  postFixup = ''
    moveToOutput bin/pcre2-config "$dev"
  '';

  meta = with lib; {
    homepage = "https://www.pcre.org/";
    description = "Perl Compatible Regular Expressions";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ttuegel ];
    platforms = platforms.all;
    pkgConfigModules = [
      "libpcre2-posix"
      "libpcre2-8"
      "libpcre2-16"
      "libpcre2-32"
    ];
  };
}
