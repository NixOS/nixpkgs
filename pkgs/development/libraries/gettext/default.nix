{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "gettext-0.17";
  
  src = fetchurl {
    url = "mirror://gnu/gettext/${name}.tar.gz";
    sha256 = "1fipjpaxxwifdw6cbr7mkxp1yvy643i38nhlh7124bqnisxki5i0";
  };

  configureFlags = "--disable-csharp";

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

//

(if (stdenv.system == "i686-darwin")
    then (stdenv.mkDerivation rec {
      name = "libiconv-1.13.1";

      src = fetchurl {
        url = "mirror://gnu/libiconv/${name}.tar.gz";
        sha256 = "0jcsjk2g28bq20yh7rvbn8xgq6q42g8dkkac0nfh12b061l638sm";
      };

      meta = {
        description = "GNU libiconv, an iconv(3) implementation";
        homepage = http://www.gnu.org/software/libiconv/;
        license = "LGPLv2+";
      };
    })
    else {})
