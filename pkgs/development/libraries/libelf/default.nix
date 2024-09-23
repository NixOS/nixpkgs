{ lib, stdenv
, fetchurl, autoreconfHook, gettext, freebsd, netbsd
}:

stdenv.mkDerivation rec {
  pname = "libelf";
  version = "0.8.13";

  src = fetchurl {
    url = "https://fossies.org/linux/misc/old/${pname}-${version}.tar.gz";
    sha256 = "0vf7s9dwk2xkmhb79aigqm0x0yfbw1j0b9ksm51207qwr179n6jr";
  };

  patches = [
    ./dont-hardcode-ar.patch
    # Fix warnings from preprocessor instructions.
    # https://github.com/NixOS/nixpkgs/issues/59929
    ./preprocessor-warnings.patch
    # `configure` defines a test `main` with an implicit `int` return, which clang 16 disallows.
    ./fix-configure-main.patch
  ];

  enableParallelBuilding = true;
  # Lacks dependencies:
  #   mkdir ...-libelf-0.8.13/lib
  #   mkdir ...-libelf-0.8.13/lib
  # mkdir: cannot create directory '...-libelf-0.8.13/lib': File exists
  enableParallelInstalling = false;

  doCheck = true;

  preConfigure = if !stdenv.hostPlatform.useAndroidPrebuilt then null else ''
    sed -i 's|DISTSUBDIRS = lib po|DISTSUBDIRS = lib|g' Makefile.in
    sed -i 's|SUBDIRS = lib @POSUB@|SUBDIRS = lib|g' Makefile.in
  '';

  configureFlags = []
       # Configure check for dynamic lib support is broken, see
       # http://lists.uclibc.org/pipermail/uclibc-cvs/2005-August/019383.html
    ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "mr_cv_target_elf=yes"
       # Libelf's custom NLS macros fail to determine the catalog file extension
       # on Darwin, so disable NLS for now.
    ++ lib.optional stdenv.hostPlatform.isDarwin "--disable-nls";

  strictDeps = true;
  nativeBuildInputs =
    (if stdenv.hostPlatform.isFreeBSD then [ freebsd.gencat ]
     else if stdenv.hostPlatform.isNetBSD then [ netbsd.gencat ]
     else [ gettext ])
       # The provided `configure` script fails on clang 16 because some tests have a `main`
       # returning an implicit `int`, which clang 16 treats as an error. Running `autoreconf` fixes
       # the test and allows `configure` to detect clang properly.
    ++ [ autoreconfHook ];

  meta = {
    description = "ELF object file access library";

    homepage = "https://github.com/Distrotech/libelf";

    license = lib.licenses.lgpl2Plus;

    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
