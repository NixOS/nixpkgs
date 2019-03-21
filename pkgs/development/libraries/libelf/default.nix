{ stdenv
, fetchurl, autoreconfHook, gettext
}:

stdenv.mkDerivation rec {
  name = "libelf-0.8.13";

  src = fetchurl {
    url = "http://www.mr511.de/software/${name}.tar.gz";
    sha256 = "0vf7s9dwk2xkmhb79aigqm0x0yfbw1j0b9ksm51207qwr179n6jr";
  };

  patches = [
    ./dont-hardcode-ar.patch
  ];

  doCheck = true;

  configureFlags = []
       # Configure check for dynamic lib support is broken, see
       # http://lists.uclibc.org/pipermail/uclibc-cvs/2005-August/019383.html
    ++ stdenv.lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "mr_cv_target_elf=yes"
       # Libelf's custom NLS macros fail to determine the catalog file extension
       # on Darwin, so disable NLS for now.
    ++ stdenv.lib.optional stdenv.hostPlatform.isDarwin "--disable-nls";

  nativeBuildInputs = [ gettext ]
       # Need to regenerate configure script with newer version in order to pass
       # "mr_cv_target_elf=yes", but `autoreconfHook` brings in `makeWrapper`
       # which doesn't work with the bootstrapTools bash, so can only do this
       # for cross builds when `stdenv.shell` is a newer bash.
    ++ stdenv.lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) autoreconfHook;

  meta = {
    description = "ELF object file access library";

    homepage = http://www.mr511.de/software/english.html;

    license = stdenv.lib.licenses.lgpl2Plus;

    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}
