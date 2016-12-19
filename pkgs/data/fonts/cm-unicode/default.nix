{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cm-unicode-${version}";
  version = "0.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/cm-unicode/cm-unicode/${version}/${name}-otf.tar.xz";
    sha256 = "0a0w9qm9g8qz2xh3lr61bj1ymqslqsvk4w2ybc3v2qa89nz7x2jl";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    mkdir -p $out/share/doc/${name}
    cp -v *.otf $out/share/fonts/opentype/
    cp -v README FontLog.txt $out/share/doc/${name}
  '';

  meta = with stdenv.lib; {
    homepage = http://canopus.iacp.dvo.ru/~panov/cm-unicode/;
    description = "Computer Modern Unicode fonts";
    maintainers = with maintainers; [ raskin rycee ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
