{stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "symbola-8.00";

  src = fetchurl {
    url = "http://users.teilar.gr/~g1951d/Symbola.zip";
    sha256 = "07bczpl3vqdpg2gakfddhzzgpb6v2wpasv7rwqxkyg9yd9lmbr0s";
  };
  docs_pdf = fetchurl {
    url = "http://users.teilar.gr/~g1951d/Symbola.pdf";
    sha256 = "1zmq1ijl0k5hrc6vpa2xp9n1x2zrrd7ng3jwc9yf0qsi3pmkpk0p";
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
    # In lieu of a license:
    # Fonts in this site are offered free for any use;
    # they may be installed, embedded, opened, edited, modified, regenerated, posted, packaged and redistributed.
    license = stdenv.lib.licenses.free;
    homepage = http://users.teilar.gr/~g1951d/;
  };
}
