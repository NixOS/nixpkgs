{ fetchurl, stdenv, libtool, readline, gmp, pkgconfig, boehmgc, libunistring
, libffi, gawk, makeWrapper, coverageAnalysis ? null, gnu ? null }:

# Do either a coverage analysis build or a standard build.
(if coverageAnalysis != null
 then coverageAnalysis
 else stdenv.mkDerivation)

(rec {
  name = "guile-2.0.5";

  src = fetchurl {
    url = "mirror://gnu/guile/${name}.tar.xz";
    sha256 = "1lycm10x316jzlv1nyag7x9gisn4d3dz8jcmbi6lbdn0z6a9skc2";
  };

  buildNativeInputs = [ makeWrapper gawk pkgconfig ];
  buildInputs = [ readline libtool libunistring libffi ];
  propagatedBuildInputs = [ gmp boehmgc ]

    # XXX: These ones aren't normally needed here, but since
    # `libguile-2.0.la' reads `-lltdl -lunistring', adding them here will add
    # the needed `-L' flags.  As for why the `.la' file lacks the `-L' flags,
    # see below.
    ++ [ libtool libunistring ];

  # A native Guile 2.0 is needed to cross-build Guile.
  selfBuildNativeInput = true;

  enableParallelBuilding = true;

  patches = [ ./disable-gc-sensitive-tests.patch ] ++
    (stdenv.lib.optional (coverageAnalysis != null) ./gcov-file-name.patch);

  postInstall = ''
    wrapProgram $out/bin/guile-snarf --prefix PATH : "${gawk}/bin"

    # XXX: See http://thread.gmane.org/gmane.comp.lib.gnulib.bugs/18903 for
    # why `--with-libunistring-prefix' and similar options coming from
    # `AC_LIB_LINKFLAGS_BODY' don't work on NixOS/x86_64.
    sed -i "$out/lib/pkgconfig/guile-2.0.pc"    \
        -e 's|-lunistring|-L${libunistring}/lib -lunistring|g ;
            s|^Cflags:\(.*\)$|Cflags: -I${libunistring}/include \1|g ;
            s|-lltdl|-L${libtool}/lib -lltdl|g'
  '';

  doCheck = true;

  setupHook = ./setup-hook.sh;

  crossAttrs.preConfigure =
    stdenv.lib.optionalString (stdenv.cross.config == "i586-pc-gnu")
       # On GNU, libgc depends on libpthread, but the cross linker doesn't
       # know where to find libpthread, which leads to erroneous test failures
       # in `configure', where `-pthread' and `-lpthread' aren't explicitly
       # passed.  So it needs some help (XXX).
       "export LDFLAGS=-Wl,-rpath-link=${gnu.libpthreadCross}/lib";


  meta = {
    description = "GNU Guile 2.0, an embeddable Scheme implementation";

    longDescription = ''
      GNU Guile is an implementation of the Scheme programming language, with
      support for many SRFIs, packaged for use in a wide variety of
      environments.  In addition to implementing the R5RS Scheme standard
      and a large subset of R6RS, Guile includes a module system, full access
      to POSIX system calls, networking support, multiple threads, dynamic
      linking, a foreign function call interface, and powerful string
      processing.
    '';

    homepage = http://www.gnu.org/software/guile/;
    license = "LGPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];

    platforms = stdenv.lib.platforms.all;
  };
}

//

(if stdenv.isFreeBSD
 then {
   # XXX: Thread support is currently broken on FreeBSD (namely the
   # `SCM_I_IS_THREAD' assertion in `scm_spawn_thread' is hit.)
   configureFlags = [ "--without-threads" ];
 }
 else {}))
