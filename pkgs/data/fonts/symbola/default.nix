{stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "symbola-8.00";

  src = fetchurl {
    url = "http://users.teilar.gr/~g1951d/Symbola.zip";
    sha256 = "1lfs2j816332ysvpb5ibj2gwpmyqyispqdl7skkshf2gra18hmhd";
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
    cp -v Symbola.pdf "$out/doc/${name}/"
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
