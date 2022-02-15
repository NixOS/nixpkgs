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
, makeWrapper
, pkg-config
, pkgsBuildBuild
, readline
}:

let
  # Do either a coverage analysis build or a standard build.
  builder = if coverageAnalysis != null
            then coverageAnalysis
            else stdenv.mkDerivation;
in
builder rec {
  pname = "guile";
  version = "2.2.7";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.xz";
    sha256 = "013mydzhfswqci6xmyc1ajzd59pfbdak15i0b090nhr9bzm7dxyd";
  };

  outputs = [ "out" "dev" "info" ];
  setOutputFlags = false; # $dev gets into the library otherwise

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ]
  ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform)
    pkgsBuildBuild.guile;
  nativeBuildInputs = [
    gawk
    makeWrapper
    pkg-config
  ];
  buildInputs = [
    libffi
    libtool
    libunistring
    readline
  ];
  propagatedBuildInputs = [
    boehmgc
    gmp

    # XXX: These ones aren't normally needed here, but `libguile*.la' has '-l'
    # flags for them without corresponding '-L' flags. Adding them here will add
    # the needed `-L' flags.  As for why the `.la' file lacks the `-L' flags,
    # see below.
    libtool
    libunistring
  ];

  # According to Bernhard M. Wiedemann <bwiedemann suse de> on
  # #reproducible-builds on irc.oftc.net, (2020-01-29): they had to
  # build Guile without parallel builds to make it reproducible.
  #
  # re: https://issues.guix.gnu.org/issue/20272
  # re: https://build.opensuse.org/request/show/732638
  enableParallelBuilding = false;

  patches = [
    # Read the header of the patch to more info
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
  ];

  postInstall = ''
    wrapProgram $out/bin/guile-snarf --prefix PATH : "${gawk}/bin"
  ''
  # XXX: See http://thread.gmane.org/gmane.comp.lib.gnulib.bugs/18903 for
  # why `--with-libunistring-prefix' and similar options coming from
  # `AC_LIB_LINKFLAGS_BODY' don't work on NixOS/x86_64.
  + ''
    sed -i "$out/lib/pkgconfig/guile"-*.pc    \
        -e "s|-lunistring|-L${libunistring}/lib -lunistring|g ;
            s|^Cflags:\(.*\)$|Cflags: -I${libunistring}/include \1|g ;
            s|-lltdl|-L${libtool.lib}/lib -lltdl|g ;
            s|includedir=$out|includedir=$dev|g
            "
    '';

  # make check doesn't work on darwin
  # On Linuxes+Hydra the tests are flaky; feel free to investigate deeper.
  doCheck = false;
  doInstallCheck = doCheck;

  setupHook = ./setup-hook-2.2.sh;

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
