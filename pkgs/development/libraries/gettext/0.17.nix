{ stdenv, fetchurl, libiconv }:

stdenv.mkDerivation rec {
  name = "gettext-0.17";
  
  src = fetchurl {
    url = "mirror://gnu/gettext/${name}.tar.gz";
    sha256 = "1fipjpaxxwifdw6cbr7mkxp1yvy643i38nhlh7124bqnisxki5i0";
  };

  configureFlags = "--disable-csharp";

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
  };
}