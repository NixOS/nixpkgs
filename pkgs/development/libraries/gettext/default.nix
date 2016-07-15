{ stdenv, lib, fetchurl, libiconv, xz }:

stdenv.mkDerivation rec {
  name = "gettext-${version}";
  version = "0.19.8";

  src = fetchurl {
    url = "mirror://gnu/gettext/${name}.tar.gz";
    sha256 = "13ylc6n3hsk919c7xl0yyibc3pfddzb53avdykn4hmk8g6yzd91x";
  };
  patches = [ ./absolute-paths.diff ];

  outputs = [ "out" "doc" ];

  # FIXME stackprotector needs gcc 4.9 in bootstrap tools
  hardeningDisable = [ "format" "stackprotector" ];

  LDFLAGS = if stdenv.isSunOS then "-lm -lmd -lmp -luutil -lnvpair -lnsl -lidmap -lavl -lsec" else "";

  configureFlags = [ "--disable-csharp" "--with-xz" ]
     ++ lib.optionals stdenv.isCygwin [
            "--disable-java"
            "--disable-native-java"
            # Share the cache among the various `configure' runs.
            "--config-cache"
            "--with-included-gettext"
            "--with-included-glib"
            "--with-included-libcroco"
        ]
     # avoid retaining reference to CF during stdenv bootstrap
     ++ lib.optionals stdenv.isDarwin [
            "gt_cv_func_CFPreferencesCopyAppValue=no"
            "gt_cv_func_CFLocaleCopyCurrent=no"
        ];

  postPatch = ''
   substituteAllInPlace gettext-runtime/src/gettext.sh.in
   substituteInPlace gettext-tools/projects/KDE/trigger --replace "/bin/pwd" pwd
   substituteInPlace gettext-tools/projects/GNOME/trigger --replace "/bin/pwd" pwd
   substituteInPlace gettext-tools/src/project-id --replace "/bin/pwd" pwd
  '';

  # On cross building, gettext supposes that the wchar.h from libc
  # does not fulfill gettext needs, so it tries to work with its
  # own wchar.h file, which does not cope well with the system's
  # wchar.h and stddef.h (gcc-4.3 - glibc-2.9)
  preConfigure = ''
    if test -n "$crossConfig"; then
      echo gl_cv_func_wcwidth_works=yes > cachefile
      configureFlags="$configureFlags --cache-file=`pwd`/cachefile"
    fi
  '' + lib.optionalString stdenv.isCygwin ''
    sed -i -e "s/\(am_libgettextlib_la_OBJECTS = \)error.lo/\\1/" gettext-tools/gnulib-lib/Makefile.in
  '';

  nativeBuildInputs = [ xz xz.bin ] ++ stdenv.lib.optional (!stdenv.isLinux) libiconv; # HACK, see #10874 (and 14664)

  enableParallelBuilding = true;

  meta = {
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

    maintainers = with lib.maintainers; [ zimbatm vrthra ];
    platforms = lib.platforms.all;
  };
}

// stdenv.lib.optionalAttrs stdenv.isDarwin {
  makeFlags = "CFLAGS=-D_FORTIFY_SOURCE=0";
}

// stdenv.lib.optionalAttrs stdenv.isCygwin {
  patchPhase =
   # Make sure `error.c' gets compiled and is part of `libgettextlib.la'.
   # This fixes:
   # gettext-0.18.1.1/gettext-tools/src/msgcmp.c:371: undefined reference to `_error_message_count'
  '' 
   sed -i gettext-tools/gnulib-lib/Makefile.in \
          -e 's/am_libgettextlib_la_OBJECTS =/am_libgettextlib_la_OBJECTS = error.lo/g'
   '';
}
