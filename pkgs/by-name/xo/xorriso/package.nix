{ lib
, stdenv
, fetchurl
, acl
, attr
, bzip2
, libcdio
, libiconv
, readline
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xorriso";
  version = "1.5.7-unstable-2023-12-06";

  src = fetchurl {
    url = "https://web.archive.org/web/20231206123448/https://www.gnu.org/software/xorriso/xorriso-1.5.7.tar.gz";
    hash = "sha256-B7lV3n3e1aF7yJsLxwi8C8m3sBmUUePpCV9KfWRuTm0=";
  };

  buildInputs = [
    bzip2
    libcdio
    libiconv
    readline
    zlib
  ]
  ++ lib.optionals stdenv.isLinux [
    acl
    attr
  ];

  outputs = [ "out" "man" ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-include unistd.h";

  doCheck = true;

  strictDeps = true;

  meta = {
    homepage = "https://www.gnu.org/software/xorriso/";
    description = "ISO 9660 Rock Ridge file system manipulator";
    longDescription = ''
      GNU xorriso copies file objects from POSIX compliant filesystems into Rock
      Ridge enhanced ISO 9660 filesystems and allows session-wise manipulation
      of such filesystems. It can load the management information of existing
      ISO images and it writes the session results to optical media or to
      filesystem objects.
      Vice versa xorriso is able to copy file objects out of ISO 9660
      filesystems.
    '';
    license = lib.licenses.gpl3Plus;
    mainProgram = "xorriso";
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
