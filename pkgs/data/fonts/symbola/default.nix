{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "symbola-7.12";

  ttf = fetchurl {
    url = "http://users.teilar.gr/~g1951d/Symbola.ttf";
    sha256 = "7acc058bd4e56cc986b2a46420520f59be402c3565c202b5dcebca7f3bfd8b5a";
  };
  docs_pdf = fetchurl {
    url = "http://users.teilar.gr/~g1951d/Symbola.pdf";
    sha256 = "11bb082ba5c2780a6f94a9bcddf4f314a54e2650bb63ce3081d1dc867c5e6843";
  };
  docs_docx = fetchurl {
    url = "http://users.teilar.gr/~g1951d/Symbola.docx";
    sha256 = "4f0ab494e1e5a7aac147aa7bb8b8bdba7278aee2da942a35f995feb9051515b9";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -v "$ttf" $out/share/fonts/truetype/"${ttf.name}"

    mkdir -p "$out/doc/${name}"
    cp -v "$docs_pdf" "$out/doc/${name}/${docs_pdf.name}"
    cp -v "$docs_docx" "$out/doc/${name}/${docs_docx.name}"
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
