{ stdenv
, callPackage
, lib
}:

let
  sources = callPackage ./sources.nix { };
in stdenv.mkDerivation rec {
  pname = "devkitPPC-binutils";
  src = sources.binutils;
  inherit (src) version;

  patches = [
    "${sources.buildscripts}/dkppc/patches/binutils-${version}.patch"
  ];

  configureFlags = [
    "--target=${sources.target}"
    "--enable-poison-system-directories"
    "--enable-plugins" "--enable-lto"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "GNU Binutils (devkitPPC)";
    homepage = "https://www.gnu.org/software/binutils/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.novenary ];
    platforms = lib.platforms.unix;
  };
}
