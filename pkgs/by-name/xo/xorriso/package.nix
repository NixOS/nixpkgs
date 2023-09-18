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
  version = "1.5.6.pl02";

  src = fetchurl {
    url = "mirror://gnu/xorriso/xorriso-${finalAttrs.version}.tar.gz";
    hash = "sha256-eG+fXfmGXMWwwf7O49LA9eBMq4yahZvRycfM1JZP2uE=";
  };

  doCheck = true;

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

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-include unistd.h";

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
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
