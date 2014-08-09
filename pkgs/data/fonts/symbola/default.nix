{ stdenv, fetchurl
, unzip                         # issue #3502
, hinted ? true }:

with stdenv; mkDerivation rec {
  name = "symbola-7.17";

  src = fetchurl {
    url = "http://users.teilar.gr/~g1951d/Symbola.zip";
    sha256 = "19q5wcqk1rz8ps7jvvx1rai6x8ais79z71sm8d36hvsk2vr135al";
  };
  docs_pdf = fetchurl {
    url = "http://users.teilar.gr/~g1951d/Symbola.pdf";
    sha256 = "11bb082ba5c2780a6f94a9bcddf4f314a54e2650bb63ce3081d1dc867c5e6843";
  };

  buildInputs = [ unzip ];  # issue #3502

  setSourceRoot = "sourceRoot=./";

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -v "Symbola${lib.optionalString hinted "_hint"}.ttf" "$out/share/fonts/truetype/"

    mkdir -p "$out/doc/${name}"
    cp -v Symbola.{docx,htm} "$out/doc/${name}/"
    cp -v "$docs_pdf" "$out/doc/${name}/${docs_pdf.name}"
  '';

  meta = {
    description = "Basic Latin, Greek, Cyrillic and many Symbol blocks of The Unicode Standard, Version 7.0";

    # In lieu of a licence:
    # Fonts in this site are offered free for any use;
    # they may be installed, embedded, opened, edited, modified, regenerated, posted, packaged and redistributed.
    license = "Unicode Fonts for Ancient Scripts";

    homepage = http://users.teilar.gr/~g1951d/;
  };
}
