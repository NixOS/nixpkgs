{ fetchurl, stdenv, gnome3 }:
stdenv.mkDerivation rec {
  name = "unicode-data-${version}";
  version = "12.0.0";
  srcs = [
    (fetchurl {
      url = "http://www.unicode.org/Public/${version}/ucd/Blocks.txt";
      sha256 = "041sk54v6rjzb23b9x7yjdwzdp2wc7gvfz7ybavgg4gbh51wm8x1";
    })
    (fetchurl {
      url = "http://www.unicode.org/Public/${version}/ucd/DerivedAge.txt";
      sha256 = "04j92xp07v273z3pxkbfmi1svmw9kmnjl9nvz9fv0g5ybk9zk7r6";
    })
    (fetchurl {
      url = "http://www.unicode.org/Public/${version}/ucd/NamesList.txt";
      sha256 = "0vsq8gx7hws8mvxy3nlglpwxw7ky57q0fs09d7w9xgb2ylk7fz61";
    })
    (fetchurl {
      url = "http://www.unicode.org/Public/${version}/ucd/Scripts.txt";
      sha256 = "18c63hx4y5yg408a8d0wx72d2hfnlz4l560y1fsf9lpzifxpqcmx";
    })
    (fetchurl {
      url = "http://www.unicode.org/Public/${version}/ucd/UnicodeData.txt";
      sha256 = "07d1kq190kgl92ispfx6zmdkvwvhjga0ishxsngzlw8j3kdkz4ap";
    })
    (fetchurl {
      url = "http://www.unicode.org/Public/${version}/ucd/Unihan.zip";
      sha256 = "1kfdhgg2gm52x3s07bijb5cxjy0jxwhd097k5lqhvzpznprm6ibf";
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
