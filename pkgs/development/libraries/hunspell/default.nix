{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  readline,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  version = "1.7.2";
  pname = "hunspell";

  src = fetchFromGitHub {
    owner = "hunspell";
    repo = "hunspell";
    rev = "v${version}";
    sha256 = "sha256-x2FXxnVIqsf5/UEQcvchAndXBv/3mW8Z55djQAFgNA8=";
  };

  outputs = [
    "bin"
    "dev"
    "out"
    "man"
  ];

  buildInputs = [
    ncurses
    readline
  ];
  nativeBuildInputs = [ autoreconfHook ];

  patches = [
    ./0001-Make-hunspell-look-in-XDG_DATA_DIRS-for-dictionaries.patch
  ];

  postPatch = ''
    patchShebangs tests
  '';

  autoreconfFlags = [ "-vfi" ];

  configureFlags = [
    "--with-ui"
    "--with-readline"
  ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage = "https://hunspell.sourceforge.net";
    description = "Spell checker";
    longDescription = ''
      Hunspell is the spell checker of LibreOffice, OpenOffice.org, Mozilla
      Firefox 3 & Thunderbird, Google Chrome, and it is also used by
      proprietary software packages, like macOS, InDesign, memoQ, Opera and
      SDL Trados.

      Main features:

      * Extended support for language peculiarities; Unicode character encoding, compounding and complex morphology.
      * Improved suggestion using n-gram similarity, rule and dictionary based pronunciation data.
      * Morphological analysis, stemming and generation.
      * Hunspell is based on MySpell and works also with MySpell dictionaries.
      * C++ library under GPL/LGPL/MPL tri-license.
      * Interfaces and ports:
        * Enchant (Generic spelling library from the Abiword project),
        * XSpell (macOS port, but Hunspell is part of the macOS from version 10.6 (Snow Leopard), and
            now it is enough to place Hunspell dictionary files into
            ~/Library/Spelling or /Library/Spelling for spell checking),
        * Delphi, Java (JNA, JNI), Perl, .NET, Python, Ruby ([1], [2]), UNO.
    '';
    platforms = platforms.all;
    license = with licenses; [
      gpl2
      lgpl21
      mpl11
    ];
    maintainers = with lib.maintainers; [ ];
  };
}
