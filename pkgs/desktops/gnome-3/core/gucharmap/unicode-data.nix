{ fetchurl, stdenv, gnome3 }:
stdenv.mkDerivation {
  name = "unicode-data-10.0.0";
  srcs = [
    (fetchurl {
      url = "http://www.unicode.org/Public/10.0.0/ucd/Blocks.txt";
      sha256 = "19zf2kd198mcv1paa194c1zf36hay1irbxssi35yi2pd8ad69qas";
    })
    (fetchurl {
      url = "http://www.unicode.org/Public/10.0.0/ucd/DerivedAge.txt";
      sha256 = "1h9p1g0wnh686l6cqar7cmky465vwc6vjzzn1s7v0i9zcjaqkr4h";
    })
    (fetchurl {
      url = "http://www.unicode.org/Public/10.0.0/ucd/NamesList.txt";
      sha256 = "0gvpcyq852rnlqmx4y5i1by7bavvcw6rj40i54w48yc7xr3zmgd1";
    })
    (fetchurl {
      url = "http://www.unicode.org/Public/10.0.0/ucd/Scripts.txt";
      sha256 = "0b9prz2hs6w61afqaplcxnv115f8yk4d5hn9dc5hks8nqpj28bnh";
    })
    (fetchurl {
      url = "http://www.unicode.org/Public/10.0.0/ucd/UnicodeData.txt";
      sha256 = "1cfak1j753zcrbgixwgppyxhm4w8vda8vxhqymi7n5ljfi6kwhjj";
    })
    (fetchurl {
      url = "http://www.unicode.org/Public/10.0.0/ucd/Unihan.zip";
      sha256 = "199kz6laypkvc0ykms6d7bkb571jmpds39sv2p7kd5jjm1ij08q1";
    })
  ];
  phases = "installPhase";
  installPhase = with stdenv.lib; ''
    mkdir $out
    for f in $srcs;do
      cp $f $out/$(stripHash $f)
    done
  '';
  meta = with stdenv.lib; {
    homepage = http://www.unicode.org/ucd/;
    description = "Unicode Character Database";
    maintainers = gnome3.maintainers;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
