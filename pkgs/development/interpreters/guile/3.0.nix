{ lib
, stdenv
, fetchurl
, fetchpatch
, boehmgc
, buildPackages
, coverageAnalysis ? null
, gawk
, gmp
, libffi
, libtool
, libunistring
, libxcrypt
, makeWrapper
, pkg-config
, pkgsBuildBuild
, readline
, writeScript
}:

let
  # Do either a coverage analysis build or a standard build.
  builder = if coverageAnalysis != null
            then coverageAnalysis
            else stdenv.mkDerivation;
in
builder rec {
  pname = "guile";
  version = "3.0.9";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-GiYlrHKyNm6VeS8/51j9Lfd1tARKkKSpeHMm5mwNdQ0=";
  };

  outputs = [ "out" "dev" "info" ];
  setOutputFlags = false; # $dev gets into the library otherwise

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ] ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform)
    pkgsBuildBuild.guile_3_0;
  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];
  buildInputs = [
    libffi
    libtool
    libunistring
    readline
  ] ++ lib.optionals stdenv.isLinux [
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
  ] ++ lib.optionals stdenv.isLinux [
    libxcrypt
  ];

  # According to
  # https://git.savannah.gnu.org/cgit/guix.git/tree/gnu/packages/guile.scm?h=a39207f7afd977e4e4299c6f0bb34bcb6d153818#n405
  # starting with Guile 3.0.8, parallel builds can be done
  # bit-reproducibly as long as we're not cross-compiling
  enableParallelBuilding = stdenv.buildPlatform == stdenv.hostPlatform;

  patches = [
    ./eai_system.patch
  ] ++ lib.optional (coverageAnalysis != null) ./gcov-file-name.patch
  ++ lib.optional stdenv.isDarwin
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gtk-osx/raw/52898977f165777ad9ef169f7d4818f2d4c9b731/patches/guile-clocktime.patch";
      sha256 = "12wvwdna9j8795x59ldryv9d84c1j3qdk2iskw09306idfsis207";
    });

  # Explicitly link against libgcc_s, to work around the infamous
  # "libgcc_s.so.1 must be installed for pthread_cancel to work".

  # don't have "libgcc_s.so.1" on clang
  LDFLAGS = lib.optionalString
    (stdenv.cc.isGNU && !stdenv.hostPlatform.isStatic) "-lgcc_s";

  configureFlags = [
    "--with-libreadline-prefix=${lib.getDev readline}"
  ] ++ lib.optionals stdenv.isSunOS [
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
  # Disable JIT on Apple Silicon, as it is not yet supported
  # https://debbugs.gnu.org/cgi/bugreport.cgi?bug=44505";
  ++ lib.optional (stdenv.isDarwin && stdenv.isAarch64) "--enable-jit=no"
  # At least on x86_64-darwin '-flto' autodetection is not correct:
  #  https://github.com/NixOS/nixpkgs/pull/160051#issuecomment-1046193028
  ++ lib.optional (stdenv.isDarwin) "--disable-lto";

  postInstall = ''
    wrapProgram $out/bin/guile-snarf --prefix PATH : "${gawk}/bin"
  ''
  # XXX: See http://thread.gmane.org/gmane.comp.lib.gnulib.bugs/18903 for
  # why `--with-libunistring-prefix' and similar options coming from
  # `AC_LIB_LINKFLAGS_BODY' don't work on NixOS/x86_64.
  + ''
    sed -i "$out/lib/pkgconfig/guile"-*.pc    \
        -e "s|-lunistring|-L${libunistring}/lib -lunistring|g ;
            s|-lltdl|-L${libtool.lib}/lib -lltdl|g ;
            s|-lcrypt|-L${libxcrypt}/lib -lcrypt|g ;
            s|^Cflags:\(.*\)$|Cflags: -I${libunistring.dev}/include \1|g ;
            s|includedir=$out|includedir=$dev|g
            "
    '';

  # make check doesn't work on darwin
  # On Linuxes+Hydra the tests are flaky; feel free to investigate deeper.
  doCheck = false;
  doInstallCheck = doCheck;

  setupHook = ./setup-hook-3.0.sh;

  passthru = rec {
    effectiveVersion = lib.versions.majorMinor version;
    siteCcacheDir = "lib/guile/${effectiveVersion}/site-ccache";
    siteDir = "share/guile/site/${effectiveVersion}";

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

  meta = with lib; {
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
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ ludo lovek323 vrthra ];
    platforms = platforms.all;
  };
}
