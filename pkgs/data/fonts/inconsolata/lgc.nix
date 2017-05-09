{stdenv, fetchFromGitHub, fontforge}:

stdenv.mkDerivation rec {
  name = "inconsolata-lgc-${version}";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "MihailJP";
    repo = "Inconsolata-LGC";
    rev = "8adfef7a7316fcd2e9a5857054c7cdb2babeb35d";
    sha256 = "0dqjj3mlc28s8ljnph6l086b4j9r5dly4fldq59crycwys72zzai";
  };

  buildInputs = [ fontforge ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -v $(find . -name '*.ttf') $out/share/fonts/truetype

    mkdir -p $out/share/fonts/opentype
    cp -v $(find . -name '*.otf') $out/share/fonts/opentype

    mkdir -p "$out/doc/${name}"
    cp -v AUTHORS ChangeLog COPYING License.txt README "$out/doc/${name}" || true
  '';

  meta = with stdenv.lib; {
    description = "Fork of Inconsolata font, with proper support of Cyrillic and Greek";
    longDescription = ''
      Inconsolata is one of the most suitable font for programmers created by Raph
      Levien. Since the original Inconsolata does not contain Cyrillic alphabet,
      it was slightly inconvenient for not a few programmers from Russia.

      Inconsolata LGC is a modified version of Inconsolata with added the Cyrillic
      alphabet which directly descends from Inconsolata Hellenic supporting modern
      Greek.

      Inconsolata LGC is licensed under SIL OFL.


      Inconsolata LGC changes:
      * Cyrillic glyphs added.
      * Italic and Bold font added.

      Changes inherited from Inconsolata Hellenic:
      * Greek glyphs.

      Changes inherited from Inconsolata-dz:
      * Straight quotation marks.
    '';

    # See `License.txt' for details.
    license = licenses.ofl;
    homepage = https://github.com/MihailJP/Inconsolata-LGC;
    maintainers = with maintainers; [ avnik rht ];
    platforms = platforms.linux;
  };
}
