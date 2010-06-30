{ stdenv, fetchurl, ncurses, readline }:

stdenv.mkDerivation rec {
  name = "hunspell-1.2.11";

  src = fetchurl {
    url = "mirror://sf/hunspell/${name}.tar.gz";
    sha256 = "14vfs1qb01hq30ss1bsiv6lkx673695g0xdyisrq720fdq2mr5rz";
  };

  propagatedBuildInputs = [ ncurses readline ];
  configureFlags = "--with-ui --with-readline";

  meta = with stdenv.lib; {
    homepage = http://hunspell.sourceforge.net;
    description = "The spell checker of OpenOffice.org and Mozilla Firefox 3 & Thunderbird, Google Chrome etc.";
    longDescription = ''
      Main features:
      * Extended support for language peculiarities; Unicode character encoding, compounding and complex morphology.
      * Improved suggestion using n-gram similarity, rule and dictionary based pronounciation data.
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
    maintainers = [ maintainers.urkud ];
  };
}
