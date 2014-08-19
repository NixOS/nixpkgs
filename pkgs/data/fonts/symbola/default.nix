{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "symbola-7.17";
  buildInputs = [unzip];

  src = fetchurl {
    url = "http://users.teilar.gr/~g1951d/Symbola.zip";
    sha256 = "549511f216536f6846435587f3d3d151a16ea2caa1ef2d8fbee8e73031e305a7";
  };
  docs_pdf = fetchurl {
    url = "http://users.teilar.gr/~g1951d/Symbola.pdf";
    sha256 = "7728bae6543f3e1fe2aa57ea32aab8619033792013d5b22db996dc7005100286";
  };

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    unzip "$src"
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -v *.ttf $out/share/fonts/truetype

    mkdir -p "$out/doc/${name}"
    cp -v "$docs_pdf" "$out/doc/${name}/${docs_pdf.name}"
    cp -v *.docx "$out/doc/${name}"
    cp -v *.htm "$out/doc/${name}"
  '';

  meta = {
    description = "Basic Latin, Greek, Cyrillic and many Symbol blocks of Unicode...";

    # In lieu of a licence:
    # Fonts in this site are offered free for any use;
    # they may be installed, embedded, opened, edited, modified, regenerated, posted, packaged and redistributed.
    license = "Unicode Fonts for Ancient Scripts";

    homepage = http://users.teilar.gr/~g1951d/;
  };
}
