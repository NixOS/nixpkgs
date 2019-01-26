{ fetchurl, stdenv, gnome3 }:
stdenv.mkDerivation rec {
  name = "unicode-data-${version}";
  version = "11.0.0";
  srcs = [
    (fetchurl {
      url = "http://www.unicode.org/Public/${version}/ucd/Blocks.txt";
      sha256 = "0lnh9iazikpr548bd7nkaq9r3vfljfvz0rg2462prac8qxk7ni8b";
    })
    (fetchurl {
      url = "http://www.unicode.org/Public/${version}/ucd/DerivedAge.txt";
      sha256 = "0rlqqd0b1sqbzvrj29dwdizx8lyvrbfirsnn8za9lb53x5fml4gb";
    })
    (fetchurl {
      url = "http://www.unicode.org/Public/${version}/ucd/NamesList.txt";
      sha256 = "0yr2h0nfqhirfi3bxl33z6cc94qqshlpgi06c25xh9754irqsgv8";
    })
    (fetchurl {
      url = "http://www.unicode.org/Public/${version}/ucd/Scripts.txt";
      sha256 = "1mbnvf97nwa3pvyzx9nd2wa94f8s0npg9740kic2p2ag7jmc1wz9";
    })
    (fetchurl {
      url = "http://www.unicode.org/Public/${version}/ucd/UnicodeData.txt";
      sha256 = "16b0jzvvzarnlxdvs2izd5ia0ipbd87md143dc6lv6xpdqcs75s9";
    })
    (fetchurl {
      url = "http://www.unicode.org/Public/${version}/ucd/Unihan.zip";
      sha256 = "0cy8gxb17ksi5h4ysypk4c09z61am1svjrvg97hm5m5ccjfrs1vj";
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
