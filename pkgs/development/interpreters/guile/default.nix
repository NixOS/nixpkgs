{ fetchurl, stdenv, libtool, readline, gmp, pkgconfig, boehmgc, libunistring
, libffi, gawk, makeWrapper, fetchpatch, coverageAnalysis ? null, gnu ? null
, hostPlatform
}:

# Do either a coverage analysis build or a standard build.
(if coverageAnalysis != null
 then coverageAnalysis
 else stdenv.mkDerivation)

(rec {
  name = "guile-${version}";
  version = "2.2.0";

  src = fetchurl {
    url = "mirror://gnu/guile/${name}.tar.xz";
    sha256 = "05dmvhd1y135x7w5qfw4my42cfp6l8bbhjfxvchcc1cbdvzri0f1";
  };

  outputs = [ "out" "dev" "info" ];
  setOutputFlags = false; # $dev gets into the library otherwise

  nativeBuildInputs = [ makeWrapper gawk pkgconfig ];
  buildInputs = [ readline libtool libunistring libffi ];

  propagatedBuildInputs = [ gmp boehmgc ]
    # XXX: These ones aren't normally needed here, but since
    # `libguile-2.0.la' reads `-lltdl -lunistring', adding them here will add
    # the needed `-L' flags.  As for why the `.la' file lacks the `-L' flags,
    # see below.
    ++ [ libtool libunistring ];

  # A native Guile 2.0 is needed to cross-build Guile.
  selfNativeBuildInput = true;

  enableParallelBuilding = true;

  patches = [
    ./eai_system.patch
  ] ++
    (stdenv.lib.optional (coverageAnalysis != null) ./gcov-file-name.patch);

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

    # XXX: See http://thread.gmane.org/gmane.comp.lib.gnulib.bugs/18903 for
    # why `--with-libunistring-prefix' and similar options coming from
    # `AC_LIB_LINKFLAGS_BODY' don't work on NixOS/x86_64.
    sed -i "$out/lib/pkgconfig/guile-2.2.pc"    \
        -e "s|-lunistring|-L${libunistring}/lib -lunistring|g ;
            s|^Cflags:\(.*\)$|Cflags: -I${libunistring}/include \1|g ;
            s|-lltdl|-L${libtool.lib}/lib -lltdl|g ;
            s|includedir=$out|includedir=$dev|g
            "
  '';

  # make check doesn't work on darwin
  # On Linuxes+Hydra the tests are flaky; feel free to investigate deeper.
  doCheck = false;

  setupHook = ./setup-hook-2.2.sh;

  crossAttrs.preConfigure =
    stdenv.lib.optionalString (hostPlatform.isHurd)
       # On GNU, libgc depends on libpthread, but the cross linker doesn't
       # know where to find libpthread, which leads to erroneous test failures
       # in `configure', where `-pthread' and `-lpthread' aren't explicitly
       # passed.  So it needs some help (XXX).
       "export LDFLAGS=-Wl,-rpath-link=${gnu.libpthreadCross}/lib";


  meta = {
    description = "Embeddable Scheme implementation";
    homepage    = http://www.gnu.org/software/guile/;
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

