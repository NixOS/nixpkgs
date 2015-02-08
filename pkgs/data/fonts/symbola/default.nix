{stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "symbola-7.19";

  src = fetchurl {
    url = "http://users.teilar.gr/~g1951d/Symbola.zip";
    sha256 = "1g7ngcxffrb9vqnmb0w9jmp349f48s0gsbi69b3g108vs8cacrmd";
  };
  docs_pdf = fetchurl {
    url = "http://users.teilar.gr/~g1951d/Symbola.pdf";
    sha256 = "16f37fsi2zyy3ka409g3m5d9c09l0ba3rqkz912j90p4588dvk85";
  };

  buildInputs = [ unzip ];

  phases = [ "installPhase" ];

  installPhase = ''
    unzip ${src}
    mkdir -p $out/share/fonts/truetype
    cp -v Symbola.ttf $out/share/fonts/truetype/
    cp -v Symbola_hint.ttf $out/share/fonts/truetype/

    mkdir -p "$out/doc/${name}"
    cp -v Symbola.docx "$out/doc/${name}/"
    cp -v Symbola.htm "$out/doc/${name}/"
    cp -v "$docs_pdf" "$out/doc/${name}/${docs_pdf.name}"
  '';

  meta = {
    description = "Basic Latin, Greek, Cyrillic and many Symbol blocks of Unicode";
    # In lieu of a licence:
    # Fonts in this site are offered free for any use;
    # they may be installed, embedded, opened, edited, modified, regenerated, posted, packaged and redistributed.
    license = stdenv.lib.licenses.free;
    homepage = http://users.teilar.gr/~g1951d/;
  };
}
