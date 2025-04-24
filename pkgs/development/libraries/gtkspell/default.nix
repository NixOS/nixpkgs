{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  docbook_xsl,
  gtk-doc,
  intltool,
  pkg-config,
  aspell,
  enchant,
  gtk2,
}:

stdenv.mkDerivation rec {
  pname = "gtkspell";
  version = "2.0.16";

  src = fetchurl {
    url = "mirror://sourceforge/gtkspell/${pname}-${version}.tar.gz";
    sha256 = "00hdv28bp72kg1mq2jdz1sdw2b8mb9iclsp7jdqwpck705bdriwg";
  };

  patches = [
    # Build with enchant 2
    # https://github.com/archlinux/svntogit-packages/tree/packages/gtkspell/trunk
    (fetchpatch {
      url = "https://github.com/archlinux/svntogit-packages/raw/17fb30b5196db378c18e7c115f28e97b962b95ff/trunk/enchant-2.diff";
      sha256 = "0d9409bnapwzwhnfpz3dvl6qalskqa4lzmhrmciazsypbw3ry5rf";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    docbook_xsl
    gtk-doc
    intltool
    pkg-config
  ];

  buildInputs = [
    aspell
    enchant
    gtk2
  ];

  meta = with lib; {
    description = "Word-processor-style highlighting and replacement of misspelled words";
    homepage = "https://gtkspell.sourceforge.net";
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
