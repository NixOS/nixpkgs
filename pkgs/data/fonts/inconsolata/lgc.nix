{stdenv, fetchFromGitHub, fontforge}:

stdenv.mkDerivation rec {
  name = "inconsolata-lgc-${version}";
  version = "git-2015-04-18";

  src = fetchFromGitHub {
    owner = "MihailJP";
    repo = "Inconsolata-LGC";
    rev = "30bbc1bd82502bf76f1cc5553f17388da2ba20e7";
    sha256 = "02af2gpksdxdp7zfh5qhgfqzc6gvah9v4ph818irwhs9gcq8833c";
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

  meta = {
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
    license = stdenv.lib.licenses.ofl;
    homepage = https://github.com/MihailJP/Inconsolata-LGC;
    maintainers = [
      stdenv.lib.maintainers.avnik
    ];
    platforms = stdenv.lib.platforms.linux;
  };
}
