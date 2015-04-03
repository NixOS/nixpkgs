{ stdenv, fetchurl, liblapack, readline, gettext, ncurses }:

stdenv.mkDerivation rec {
  name = "gnu-apl-${version}";
  version = "1.4";

  src = fetchurl {
    url = "mirror://gnu/apl/apl-${version}.tar.gz";
    sha256 = "0fl9l4jb5wpnb54kqkphavi657z1cv15h9qj2rqy2shf33dk3nk9";
  };

  buildInputs = [ liblapack readline gettext ncurses ];

  postInstall = ''
    cp -r support-files/ $out/share/doc/
    find $out/share/doc/support-files -name 'Makefile*' -delete
  '';

  meta = {
    description = "Free interpreter for the APL programming language.";
    homepage    = http://www.gnu.org/software/apl/;
    license     = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ kovirobi ];
    platforms   = stdenv.lib.platforms.linux;

    longDescription = ''
      GNU APL is a free interpreter for the programming language APL, with an
      (almost) complete implementation of ISO standard 13751 aka.  Programming
      Language APL, Extended.  GNU APL was written and is being maintained by
      Jürgen Sauermann.
    '';
  };
}
