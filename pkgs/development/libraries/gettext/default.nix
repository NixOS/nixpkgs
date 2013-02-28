{ stdenv, fetchurl, libiconv }:

stdenv.mkDerivation (rec {
  name = "gettext-0.18.2";
  
  src = fetchurl {
    url = "mirror://gnu/gettext/${name}.tar.gz";
    sha256 = "516a6370b3b3f46e2fc5a5e222ff5ecd76f3089bc956a7587a6e4f89de17714c";
  };

  patches = [ ./no-gets.patch ];

  LDFLAGS = if stdenv.isSunOS then "-lm -lmd -lmp -luutil -lnvpair -lnsl -lidmap -lavl -lsec" else "";

  configureFlags = [ "--disable-csharp" ]
     ++ (stdenv.lib.optionals stdenv.isCygwin
          [ # We have a static libiconv, so we can only build the static lib.
            "--disable-shared" "--enable-static"

            # Share the cache among the various `configure' runs.
            "--config-cache"
          ]);

  # On cross building, gettext supposes that the wchar.h from libc
  # does not fulfill gettext needs, so it tries to work with its
  # own wchar.h file, which does not cope well with the system's
  # wchar.h and stddef.h (gcc-4.3 - glibc-2.9)
  preConfigure = ''
    if test -n "$crossConfig"; then
      echo gl_cv_func_wcwidth_works=yes > cachefile
      configureFlags="$configureFlags --cache-file=`pwd`/cachefile"
    fi
  '';

  buildInputs = stdenv.lib.optional (!stdenv.isLinux) libiconv;
  
  enableParallelBuilding = true;
      
  crossAttrs = {
    buildInputs = stdenv.lib.optional (stdenv.gccCross.libc ? libiconv)
      stdenv.gccCross.libc.libiconv.crossDrv;
    # Gettext fails to guess the cross compiler
    configureFlags = "CXX=${stdenv.cross.config}-g++";
  };

  meta = {
    description = "GNU gettext, a well integrated set of translation tools and documentation";

    longDescription = ''
      Usually, programs are written and documented in English, and use
      English at execution time for interacting with users.  Using a common
      language is quite handy for communication between developers,
      maintainers and users from all countries.  On the other hand, most
      people are less comfortable with English than with their own native
      language, and would rather be using their mother tongue for day to
      day's work, as far as possible.  Many would simply love seeing their
      computer screen showing a lot less of English, and far more of their
      own language.

      GNU `gettext' is an important step for the GNU Translation Project, as
      it is an asset on which we may build many other steps. This package
      offers to programmers, translators, and even users, a well integrated
      set of tools and documentation. Specifically, the GNU `gettext'
      utilities are a set of tools that provides a framework to help other
      GNU packages produce multi-lingual messages.
    '';

    homepage = http://www.gnu.org/software/gettext/;

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}

//

stdenv.lib.optionalAttrs stdenv.isCygwin {
  patchPhase =
   # Make sure `error.c' gets compiled and is part of `libgettextlib.la'.
   # This fixes:
   # gettext-0.18.1.1/gettext-tools/src/msgcmp.c:371: undefined reference to `_error_message_count'

   '' sed -i gettext-tools/gnulib-lib/Makefile.in \
          -e 's/am_libgettextlib_la_OBJECTS =/am_libgettextlib_la_OBJECTS = error.lo/g'
   '';
})
