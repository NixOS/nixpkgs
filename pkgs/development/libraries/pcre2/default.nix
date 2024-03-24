{ lib
, stdenv
, fetchurl
, withJitSealloc ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pcre2";
  version = "10.43";

  src = fetchurl {
    url = "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-${finalAttrs.version}/pcre2-${finalAttrs.version}.tar.bz2";
    hash = "sha256-4qU5hP8LB9/bWuRIa7ubIcyo598kNAlsyb8bcow1C8s=";
  };

  patches = [
    # Remove this patch when version > 10.43.
   ./fix-jit-support-autodetection.patch
  ];

  configureFlags = [
    "--enable-pcre2-16"
    "--enable-pcre2-32"
    # only enable jit on supported platforms which excludes Apple Silicon, see https://github.com/zherczeg/sljit/issues/51
    "--enable-jit=${if stdenv.hostPlatform.isS390x then "no" else "auto"}"
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
    changelog = "https://github.com/PCRE2Project/pcre2/blob/pcre2-${finalAttrs.version}/ChangeLog";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ttuegel ];
    mainProgram = "pcre2grep";
    platforms = platforms.all;
    pkgConfigModules = [
      "libpcre2-posix"
      "libpcre2-8"
      "libpcre2-16"
      "libpcre2-32"
    ];
  };
})
