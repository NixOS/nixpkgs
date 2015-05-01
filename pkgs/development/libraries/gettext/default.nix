{ stdenv, fetchurl, libiconv, xz }:

let
  inherit (stdenv) isCygwin isDarwin isLinux isSunOS;
  inherit (stdenv.lib) optional optionals optionalAttrs;
in

stdenv.mkDerivation (rec {
  name = "gettext-0.18.3.2";

  src = fetchurl {
    url = "mirror://gnu/gettext/${name}.tar.gz";
    sha256 = "1my5njl7mp663abpdn8qsm5i462wlhlnb5q50fmhgd0fsr9f996i";
  };

  LDFLAGS = if isSunOS then "-lm -lmd -lmp -luutil -lnvpair -lnsl -lidmap -lavl -lsec" else "";

  configureFlags = [
    "--disable-csharp"
    "--with-xz"
  ] ++ (optionals isCygwin [
    # We have a static libiconv on Cygwin, so we can only build the static lib.
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

  buildInputs = [ xz ] ++ optional (!isLinux) libiconv;

  enableParallelBuilding = true;

  crossAttrs = {
    buildInputs = optional (stdenv ? ccCross && stdenv.ccCross.libc ? libiconv)
      stdenv.ccCross.libc.libiconv.crossDrv;
    # Gettext fails to guess the cross compiler
    configureFlags = "CXX=${stdenv.cross.config}-g++";
  };

  meta = with stdenv.lib; {
    description = "Well integrated set of translation tools and documentation";
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
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}

// optionalAttrs isDarwin {
  makeFlags = "CFLAGS=-D_FORTIFY_SOURCE=0";
}

// optionalAttrs isCygwin {
  patchPhase =
   # Make sure `error.c' gets compiled and is part of `libgettextlib.la'.
   # This fixes:
   # gettext-0.18.1.1/gettext-tools/src/msgcmp.c:371: undefined reference to `_error_message_count'

   '' sed -i gettext-tools/gnulib-lib/Makefile.in \
          -e 's/am_libgettextlib_la_OBJECTS =/am_libgettextlib_la_OBJECTS = error.lo/g'
   '';
})
