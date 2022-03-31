{ lib
, stdenv
, fetchurl
, buildPackages
, gawk
, gmp
, libtool
, makeWrapper
, pkg-config
, pkgsBuildBuild
, readline
}:

stdenv.mkDerivation rec {
  pname = "guile";
  version = "1.8.8";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0l200a0v7h8bh0cwz6v7hc13ds39cgqsmfrks55b1rbj5vniyiy3";
  };

  outputs = [ "out" "dev" "info" ];
  setOutputFlags = false; # $dev gets into the library otherwise

  # GCC 4.6 raises a number of set-but-unused warnings.
  configureFlags = [
    "--disable-error-on-warning"
  ]
  # Guile needs patching to preset results for the configure tests about
  # pthreads, which work only in native builds.
  ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform)
    "--with-threads=no";

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ]
  ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform)
    pkgsBuildBuild.guile_1_8;
  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];
  buildInputs = [
    libtool
    readline
  ];
  propagatedBuildInputs = [
    gmp

    # XXX: These ones aren't normally needed here, but `libguile*.la' has '-l'
    # flags for them without corresponding '-L' flags. Adding them here will add
    # the needed `-L' flags.  As for why the `.la' file lacks the `-L' flags,
    # see below.
    libtool
  ];

  patches = [
    # Fix doc snarfing with GCC 4.5.
    ./cpp-4.5.patch
    # Self explanatory
    ./CVE-2016-8605.patch
  ];

  preBuild = ''
    sed -e '/lt_dlinit/a  lt_dladdsearchdir("'$out/lib'");' -i libguile/dynl.c
  '';

  postInstall = ''
    wrapProgram $out/bin/guile-snarf --prefix PATH : "${gawk}/bin"
  ''
  # XXX: See http://thread.gmane.org/gmane.comp.lib.gnulib.bugs/18903 for
  # why `--with-libunistring-prefix' and similar options coming from
  # `AC_LIB_LINKFLAGS_BODY' don't work on NixOS/x86_64.
  + ''
    sed -i "$out/lib/pkgconfig/guile"-*.pc    \
        -e "s|-lltdl|-L${libtool.lib}/lib -lltdl|g"
  '';

  # One test fails.
  # ERROR: file: "libtest-asmobs", message: "file not found"
  # This is fixed here:
  # <https://git.savannah.gnu.org/cgit/guile.git/commit/?h=branch_release-1-8&id=a0aa1e5b69d6ef0311aeea8e4b9a94eae18a1aaf>.
  doCheck = false;
  doInstallCheck = doCheck;

  setupHook = ./setup-hook-1.8.sh;

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
    maintainers = with maintainers; [ ludo ];
    platforms = platforms.all;
  };
}
