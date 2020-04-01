{ stdenv, pkgsBuildBuild, buildPackages
, fetchurl, makeWrapper, gawk, pkgconfig
, libffi, libtool, readline, gmp, boehmgc, libunistring
, coverageAnalysis ? null
, fetchpatch
}:

# Do either a coverage analysis build or a standard build.
(if coverageAnalysis != null
 then coverageAnalysis
 else stdenv.mkDerivation)

(rec {
  name = "guile-${version}";
  version = "2.2.7";

  src = fetchurl {
    url = "mirror://gnu/guile/${name}.tar.xz";
    sha256 = "013mydzhfswqci6xmyc1ajzd59pfbdak15i0b090nhr9bzm7dxyd";
  };

  outputs = [ "out" "dev" "info" ];
  setOutputFlags = false; # $dev gets into the library otherwise

  depsBuildBuild = [ buildPackages.stdenv.cc ]
    ++ stdenv.lib.optional (stdenv.hostPlatform != stdenv.buildPlatform)
                           pkgsBuildBuild.guile;
  nativeBuildInputs = [ makeWrapper gawk pkgconfig ];
  buildInputs = [ readline libtool libunistring libffi ];

  propagatedBuildInputs = [
    gmp boehmgc

    # XXX: These ones aren't normally needed here, but `libguile*.la' has '-l'
    # flags for them without corresponding '-L' flags. Adding them here will add
    # the needed `-L' flags.  As for why the `.la' file lacks the `-L' flags,
    # see below.
    libtool libunistring
  ];

  enableParallelBuilding = true;

  patches = [
    ./eai_system.patch
  ] ++ stdenv.lib.optional (coverageAnalysis != null) ./gcov-file-name.patch
    ++ stdenv.lib.optional stdenv.isDarwin (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gtk-osx/raw/52898977f165777ad9ef169f7d4818f2d4c9b731/patches/guile-clocktime.patch";
      sha256 = "12wvwdna9j8795x59ldryv9d84c1j3qdk2iskw09306idfsis207";
    });

  # Explicitly link against libgcc_s, to work around the infamous
  # "libgcc_s.so.1 must be installed for pthread_cancel to work".

  # don't have "libgcc_s.so.1" on darwin
  LDFLAGS = stdenv.lib.optionalString (!stdenv.isDarwin) "-lgcc_s";

  configureFlags = [ "--with-libreadline-prefix=${readline.dev}" ]
    ++ stdenv.lib.optionals stdenv.isSunOS [
      # Make sure the right <gmp.h> is found, and not the incompatible
      # /usr/include/mp.h from OpenSolaris.  See
      # <https://lists.gnu.org/archive/html/hydra-users/2012-08/msg00000.html>
      # for details.
      "--with-libgmp-prefix=${gmp.dev}"

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

  meta = {
    description = "Embeddable Scheme implementation";
    homepage    = "https://www.gnu.org/software/guile/";
    license     = stdenv.lib.licenses.lgpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ ludo lovek323 vrthra ];
    platforms   = stdenv.lib.platforms.all;

    longDescription = ''
      GNU Guile is an implementation of the Scheme programming language, with
      support for many SRFIs, packaged for use in a wide variety of
      environments.  In addition to implementing the R5RS Scheme standard
      and a large subset of R6RS, Guile includes a module system, full access
      to POSIX system calls, networking support, multiple threads, dynamic
      linking, a foreign function call interface, and powerful string
      processing.
    '';
  };
})

