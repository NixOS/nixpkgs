{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkgsBuildBuild,
  boehmgc,
  gawk,
  gmp,
  libffi,
  libtool,
  libunistring,
  libxcrypt,
  makeWrapper,
  pkg-config,
  autoreconfHook,
  readline,
  writeScript,

  coverageAnalysis ? null,
}:

let
  # Do either a coverage analysis build or a standard build.
  builder = if coverageAnalysis != null then coverageAnalysis else stdenv.mkDerivation;
in
builder (finalAttrs: {
  pname = "guile";
  version = "3.0.10";

  src = fetchurl {
    url = "mirror://gnu/guile/guile-${finalAttrs.version}.tar.xz";
    hash = "sha256-vXFoUX/VJjM0RtT3q4FlJ5JWNAlPvTcyLhfiuNjnY4g=";
  };

  patches = [
    ./eai_system.patch
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gtk-osx/raw/52898977f165777ad9ef169f7d4818f2d4c9b731/patches/guile-clocktime.patch";
      hash = "sha256-BwgdtWvRgJEAnzqK2fCQgRHU0va50VR6SQfJpGzjm4s=";
    })
    (fetchpatch {
      url = "https://cgit.git.savannah.gnu.org/cgit/guile.git/patch/?id=c117f8edc471d3362043d88959d73c6a37e7e1e9";
      hash = "sha256-GFwJiwuU8lT1fNueMOcvHh8yvA4HYHcmPml2fY/HSjw=";
    })
  ]
  ++ lib.optional (coverageAnalysis != null) ./gcov-file-name.patch;

  outputs = [
    "out"
    "dev"
    "info"
  ];
  setOutputFlags = false; # $dev gets into the library otherwise

  strictDeps = true;
  depsBuildBuild = [
    pkgsBuildBuild.stdenv.cc
  ]
  ++ lib.optional (
    !lib.systems.equals stdenv.hostPlatform stdenv.buildPlatform
  ) pkgsBuildBuild.guile_3_0;

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    libffi
    libtool
    libunistring
    readline
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libxcrypt
  ];

  propagatedBuildInputs = [
    boehmgc
    gmp

    # These ones aren't normally needed here, but `libguile*.la' has '-l'
    # flags for them without corresponding '-L' flags. Adding them here will
    # add the needed `-L' flags.  As for why the `.la' file lacks the `-L'
    # flags, see below.
    libtool
    libunistring
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libxcrypt
  ];

  # According to
  # https://git.savannah.gnu.org/cgit/guix.git/tree/gnu/packages/guile.scm?h=a39207f7afd977e4e4299c6f0bb34bcb6d153818#n405
  # starting with Guile 3.0.8, parallel builds can be done
  # bit-reproducibly as long as we're not cross-compiling
  enableParallelBuilding = lib.systems.equals stdenv.buildPlatform stdenv.hostPlatform;

  # Explicitly link against libgcc_s, to work around the infamous
  # "libgcc_s.so.1 must be installed for pthread_cancel to work".

  # don't have "libgcc_s.so.1" on clang
  env.LDFLAGS = lib.optionalString (stdenv.cc.isGNU && !stdenv.hostPlatform.isStatic) "-lgcc_s";

  configureFlags = [
    "--with-libreadline-prefix=${lib.getDev readline}"
    "AWK=${lib.getExe gawk}"
  ]
  ++ lib.optionals stdenv.hostPlatform.isSunOS [
    # Make sure the right <gmp.h> is found, and not the incompatible
    # /usr/include/mp.h from OpenSolaris.  See
    # <https://lists.gnu.org/archive/html/hydra-users/2012-08/msg00000.html>
    # for details.
    "--with-libgmp-prefix=${lib.getDev gmp}"

    # Same for these (?).
    "--with-libunistring-prefix=${libunistring}"

    # See below.
    "--without-threads"
  ]
  # At least on x86_64-darwin '-flto' autodetection is not correct:
  #  https://github.com/NixOS/nixpkgs/pull/160051#issuecomment-1046193028
  ++ lib.optional (stdenv.hostPlatform.isDarwin) "--disable-lto";

  # XXX: See http://thread.gmane.org/gmane.comp.lib.gnulib.bugs/18903 for
  # why `--with-libunistring-prefix' and similar options coming from
  # `AC_LIB_LINKFLAGS_BODY' don't work on NixOS/x86_64.
  postInstall = ''
    substituteInPlace "$out/lib/pkgconfig/guile"*.pc \
      --replace-fail "-lunistring" "-L${libunistring}/lib -lunistring" \
      --replace-fail "-lcrypt" "-L${libxcrypt}/lib -lcrypt" \
      --replace-fail "includedir=$out" "includedir=$dev"

    sed -i "$out/lib/pkgconfig/guile"*.pc    \
        -e "s|^Cflags:\(.*\)$|Cflags: -I${libunistring.dev}/include \1|g ;"
  '';

  # make check doesn't work on darwin
  # On Linuxes+Hydra the tests are flaky; feel free to investigate deeper.
  doCheck = false;
  doInstallCheck = finalAttrs.doCheck;

  # guile-3 uses ELF files to store bytecode. strip does not
  # always handle them correctly and destroys the image:
  # darwin: In procedure bytevector-u8-ref: Argument 2 out of range
  # linux binutils-2.45: $ guile --version
  # Pre-boot error; key: misc-error, args: ("load-thunk-from-memory" "missing DT_GUILE_ENTRY" () #f)Aborted
  dontStrip = true;

  setupHook = ./setup-hook-3.0.sh;

  passthru = {
    effectiveVersion = lib.versions.majorMinor finalAttrs.version;
    siteCcacheDir = "lib/guile/${finalAttrs.effectiveVersion}/site-ccache";
    siteDir = "share/guile/site/${finalAttrs.effectiveVersion}";

    updateScript = writeScript "update-guile-3" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre common-updater-scripts

      set -eu -o pipefail

      # Expect the text in format of '"https://ftp.gnu.org/gnu/guile/guile-3.0.8.tar.gz"'
      new_version="$(curl -s https://www.gnu.org/software/guile/download/ |
          pcregrep -o1 '"https://ftp.gnu.org/gnu/guile/guile-(3[.0-9]+).tar.gz"')"
      update-source-version guile_3_0 "$new_version"
    '';
  };

  meta = {
    homepage = "https://www.gnu.org/software/guile/";
    description = "Embeddable Scheme implementation";
    longDescription = ''
      GNU Guile is an implementation of the Scheme programming language, with
      support for many SRFIs, packaged for use in a wide variety of
      environments.  In addition to implementing the R5RS Scheme standard and a
      large subset of R6RS, Guile includes a module system, full access to POSIX
      system calls, networking support, multiple threads, dynamic linking, a
      foreign function call interface, and powerful string processing.
    '';
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.RossSmyth ];
    platforms = lib.platforms.all;
  };
})
