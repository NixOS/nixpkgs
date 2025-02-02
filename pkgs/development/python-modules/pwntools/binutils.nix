{
  stdenv,
  binutils-unwrapped,
  bison,
  buildPackages,
  fetchFromGitHub,
  fetchurl,
  gettext,
  lib,
  perl,
  zlib,
  texinfo,
  targetArch,
}:

let
  version = "2.43.1";
  target = targetArch + "-unknown-linux-gnu";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "binutils-cross-" + targetArch;
  inherit version;

  src = binutils-unwrapped.src;

  strictDeps = true;
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    texinfo
    bison
    perl
  ];

  buildInputs = [
    zlib
    gettext
  ];

  configureFlags = [
    "--enable-64-bit-bfd"
    "--with-system-zlib"

    "--disable-werror"

    # force target prefix. Some versions of binutils will make it empty if
    # `--host` and `--target` are too close, even if Nixpkgs thinks the
    # platforms are different (e.g. because not all the info makes the
    # `config`). Other versions of binutils will always prefix if `--target` is
    # passed, even if `--host` and `--target` are the same. The easiest thing
    # for us to do is not leave it to chance, and force the program prefix to be
    # what we want it to be.
    "--program-prefix=${target}-"

    # Unconditionally disable:
    # - musl target needs porting: https://sourceware.org/PR29477
    "--disable-gprofng"

    "--target=${target}"

    "--disable-static"
    "--disable-multilib"
    "--disable-werror"
    "--disable-nls"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Tools for manipulating binaries (linker, assembler, etc.)";
    longDescription = ''
      The GNU Binutils are a collection of binary tools.  The main
      ones are `ld' (the GNU linker) and `as' (the GNU assembler).
      They also include the BFD (Binary File Descriptor) library,
      `gprof', `nm', `strip', etc.
    '';
    homepage = "https://www.gnu.org/software/binutils/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      kristoff3r
      TethysSvensson
    ];
    platforms = platforms.unix;
  };
})
