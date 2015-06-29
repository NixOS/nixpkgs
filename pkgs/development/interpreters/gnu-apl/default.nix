{ stdenv, fetchurl, readline, gettext, ncurses }:

stdenv.mkDerivation rec {
  name = "gnu-apl-${version}";
  version = "1.5";

  src = fetchurl {
    url = "mirror://gnu/apl/apl-${version}.tar.gz";
    sha256 = "0h4diq3wfbdwxp5nm0z4b0p1zq13lwip0y7v28r9v0mbbk8xsfh1";
  };

  buildInputs = [ readline gettext ncurses ];

  postInstall = ''
    cp -r support-files/ $out/share/doc/
    find $out/share/doc/support-files -name 'Makefile*' -delete
  '';

  meta = with stdenv.lib; {
    description = "Free interpreter for the APL programming language";
    homepage    = http://www.gnu.org/software/apl/;
    license     = licenses.gpl3Plus;
    maintainers = [ maintainers.kovirobi ];
    platforms   = stdenv.lib.platforms.linux;
    inherit version;

    longDescription = ''
      GNU APL is a free interpreter for the programming language APL, with an
      (almost) complete implementation of ISO standard 13751 aka.  Programming
      Language APL, Extended.  GNU APL was written and is being maintained by
      Jürgen Sauermann.
    '';
  };
}
