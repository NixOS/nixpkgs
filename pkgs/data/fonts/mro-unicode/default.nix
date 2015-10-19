{ lib, runCommand, fetchurl }:

runCommand "mro-unicode-2013-05-25" {
  src = fetchurl {
    url = "https://github.com/phjamr/MroUnicode/raw/master/MroUnicode-Regular.ttf";
    sha256 = "1za74ych0sh97ks6qp9iqq9jankgnkrq65s350wsbianwi72di45";
  };

  meta = with lib; {
    homepage = https://github.com/phjamr/MroUnicode;
    description = "Unicode-compliant Mro font";
    maintainers = with maintainers; [ mathnerd314 ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
''
  mkdir -p $out/share/fonts/truetype
  cp $src $out/share/fonts/truetype/MroUnicode-Regular.ttf
''
