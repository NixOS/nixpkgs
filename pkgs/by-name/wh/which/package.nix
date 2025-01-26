{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "which";
  version = "2.21";

  src = fetchurl {
    url = "mirror://gnu/which/which-${version}.tar.gz";
    hash = "sha256-9KJFuUEks3fYtJZGv0IfkVXTaqdhS26/g3BdP/x26q0=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = toString (
    # Enable 64-bit file API. Otherwise `which` fails to find tools
    # on filesystems with 64-bit inodes (like `btrfs`) when running
    # binaries from 32-bit systems (like `i686-linux`).
    lib.optional stdenv.hostPlatform.is32bit "-D_FILE_OFFSET_BITS=64"
  );

  meta = {
    homepage = "https://www.gnu.org/software/which/";
    description = "Shows the full path of (shell) commands";
    license = lib.licenses.gpl3Plus;
    mainProgram = "which";
    platforms = lib.platforms.all;
  };
}
