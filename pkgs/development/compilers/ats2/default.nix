{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  name    = "ats2-${version}";
  version = "0.2.7";

  src = fetchurl {
    url = "mirror://sourceforge/ats2-lang/ATS2-Postiats-${version}.tgz";
    sha256 = "1w9cncahv0vkqsj4vlfnn7bn61jvgxgjhk7wbppcm3yhb48pkmda";
  };

  buildInputs = [ gmp ];

  setupHook = ./setup-hook.sh;

  meta = with stdenv.lib; {
    description = "Functional programming language with dependent types";
    homepage    = "http://www.ats-lang.org";
    license     = licenses.gpl3Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ttuegel ];
  };
}
