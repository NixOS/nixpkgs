{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  boehmgc,
  buildPackages,
  coverageAnalysis ? null,
  gawk,
  gmp,
  libffi,
  libtool,
  libunistring,
  makeWrapper,
  pkg-config,
  pkgsBuildBuild,
  readline,
}:

let
  # Do either a coverage analysis build or a standard build.
  builder = if coverageAnalysis != null then coverageAnalysis else stdenv.mkDerivation;
in
builder rec {
  pname = "guile";
  version = "2.0.13";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.xz";
    sha256 = "12yqkr974y91ylgw6jnmci2v90i90s7h9vxa4zk0sai8vjnz4i1p";
  };

  outputs = [
    "out"
    "dev"
    "info"
  ];
  setOutputFlags = false; # $dev gets into the library otherwise

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ] ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) pkgsBuildBuild.guile_2_0;

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];
  buildInputs = [
    readline
    libtool
    libunistring
    libffi
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
  ];

  enableParallelBuilding = true;

  patches =
    [
      # Small fixes to Clang compiler
      ./clang.patch
      # Self-explanatory
      ./disable-gc-sensitive-tests.patch
      # Read the header of the patch to more info
      ./eai_system.patch
      # RISC-V endianness
      ./riscv.patch
      # Fixes stability issues with 00-repl-server.test
      (fetchpatch {
        url = "https://git.savannah.gnu.org/cgit/guile.git/patch/?id=2fbde7f02adb8c6585e9baf6e293ee49cd23d4c4";
        sha256 = "0p6c1lmw1iniq03z7x5m65kg3lq543kgvdb4nrxsaxjqf3zhl77v";
      })
    ]
    ++ (lib.optional (coverageAnalysis != null) ./gcov-file-name.patch)
    ++ lib.optionals stdenv.isDarwin [
      ./filter-mkostemp-darwin.patch
      (fetchpatch {
        url = "https://gitlab.gnome.org/GNOME/gtk-osx/raw/52898977f165777ad9ef169f7d4818f2d4c9b731/patches/guile-clocktime.patch";
        sha256 = "12wvwdna9j8795x59ldryv9d84c1j3qdk2iskw09306idfsis207";
      })
    ];

  # Explicitly link against libgcc_s, to work around the infamous
  # "libgcc_s.so.1 must be installed for pthread_cancel to work".

  # don't have "libgcc_s.so.1" on darwin
  LDFLAGS = lib.optionalString (!stdenv.isDarwin && !stdenv.hostPlatform.isMusl) "-lgcc_s";

  configureFlags =
    [
      "--with-libreadline-prefix"
    ]
    ++ lib.optionals stdenv.isSunOS [
      # Make sure the right <gmp.h> is found, and not the incompatible
      # /usr/include/mp.h from OpenSolaris. See
      # <https://lists.gnu.org/archive/html/hydra-users/2012-08/msg00000.html>
      # for details.
      "--with-libgmp-prefix=${lib.getDev gmp}"

      # Same for these (?).
      "--with-libreadline-prefix=${lib.getDev readline}"
      "--with-libunistring-prefix=${libunistring}"

      # See below.
      "--without-threads"
    ];

  postInstall =
    ''
      wrapProgram $out/bin/guile-snarf --prefix PATH : "${gawk}/bin"
    ''
    # XXX: See http://thread.gmane.org/gmane.comp.lib.gnulib.bugs/18903 for
    # why `--with-libunistring-prefix' and similar options coming from
    # `AC_LIB_LINKFLAGS_BODY' don't work on NixOS/x86_64.
    + ''
      sed -i "$out/lib/pkgconfig/guile"-*.pc    \
          -e "s|-lunistring|-L${libunistring}/lib -lunistring|g ;
              s|^Cflags:\(.*\)$|Cflags: -I${libunistring.dev}/include \1|g ;
              s|-lltdl|-L${libtool.lib}/lib -lltdl|g ;
              s|includedir=$out|includedir=$dev|g
              "
    '';

  # make check doesn't work on darwin
  # On Linuxes+Hydra the tests are flaky; feel free to investigate deeper.
  doCheck = false;
  doInstallCheck = doCheck;

  setupHook = ./setup-hook-2.0.sh;

  passthru = rec {
    effectiveVersion = lib.versions.majorMinor version;
    siteCcacheDir = "lib/guile/${effectiveVersion}/site-ccache";
    siteDir = "share/guile/site/${effectiveVersion}";
  };

  meta = with lib; {
    homepage = "https://www.gnu.org/software/guile/";
    description = "Embeddable Scheme implementation";
    longDescription = ''
      GNU Guile is an implementation of the Scheme programming language, with
      support for many SRFIs, packaged for use in a wide variety of
      environments.  In addition to implementing the R5RS Scheme standard and
      a large subset of R6RS, Guile includes a module system, full access to
      POSIX system calls, networking support, multiple threads, dynamic
      linking, a foreign function call interface, and powerful string
      processing.
    '';
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [
      ludo
      lovek323
      vrthra
    ];
    platforms = platforms.all;
  };
}

//

  (lib.optionalAttrs (!stdenv.isLinux) {
    # Work around <https://bugs.gnu.org/14201>.
    SHELL = stdenv.shell;
    CONFIG_SHELL = stdenv.shell;
  })
