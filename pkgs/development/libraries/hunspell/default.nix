{ stdenv, fetchurl, ncurses, readline }:

stdenv.mkDerivation rec {
  name = "hunspell-1.3.3";

  src = fetchurl {
    url = "mirror://sourceforge/hunspell/${name}.tar.gz";
    sha256 = "0v14ff9s37vkh45diaddndcrj0hmn67arh8xh8k79q9c1vgc1cm7";
  };

  propagatedBuildInputs = [ ncurses readline ];
  configureFlags = "--with-ui --with-readline";

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage = http://hunspell.sourceforge.net;
    description = "Spell checker";
    longDescription = ''
      Hunspell is the spell checker of LibreOffice, OpenOffice.org, Mozilla
      Firefox 3 & Thunderbird, Google Chrome, and it is also used by
      proprietary software packages, like Mac OS X, InDesign, memoQ, Opera and
      SDL Trados.

      Main features:

      * Extended support for language peculiarities; Unicode character encoding, compounding and complex morphology.
      * Improved suggestion using n-gram similarity, rule and dictionary based pronunciation data.
      * Morphological analysis, stemming and generation.
      * Hunspell is based on MySpell and works also with MySpell dictionaries.
      * C++ library under GPL/LGPL/MPL tri-license.
      * Interfaces and ports:
        * Enchant (Generic spelling library from the Abiword project),
        * XSpell (Mac OS X port, but Hunspell is part of the OS X from version 10.6 (Snow Leopard), and
            now it is enough to place Hunspell dictionary files into
            ~/Library/Spelling or /Library/Spelling for spell checking),
        * Delphi, Java (JNA, JNI), Perl, .NET, Python, Ruby ([1], [2]), UNO.
    '';
    platforms = platforms.all;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
