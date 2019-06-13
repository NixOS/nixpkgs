{ lib, fetchzip }:

let
  version = "0.7.0";
in fetchzip rec {
  name = "cm-unicode-${version}";

  url = "mirror://sourceforge/cm-unicode/cm-unicode/${version}/${name}-otf.tar.xz";

  postFetch = ''
    tar -xJvf $downloadedFile --strip-components=1
    install -m444 -Dt $out/share/fonts/opentype *.otf
    install -m444 -Dt $out/share/doc/${name}    README FontLog.txt
  '';

  sha256 = "1rzz7yhqq3lljyqxbg46jfzfd09qgpgx865lijr4sgc94riy1ypn";

  meta = with lib; {
    homepage = http://canopus.iacp.dvo.ru/~panov/cm-unicode/;
    description = "Computer Modern Unicode fonts";
    maintainers = with maintainers; [ raskin rycee ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
