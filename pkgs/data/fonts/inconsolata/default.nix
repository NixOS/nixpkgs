{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "inconsolata-${version}";
  version = "1.010";

  src = fetchurl {
    url = "http://www.levien.com/type/myfonts/Inconsolata.otf";
    sha256 = "06js6znbcf7swn8y3b8ki416bz96ay7d3yvddqnvi88lqhbfcq8m";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp -v $src $out/share/fonts/opentype/inconsolata.otf
  '';

  meta = with stdenv.lib; {
    homepage = http://www.levien.com/type/myfonts/inconsolata.html;
    description = "A monospace font for both screen and print";
    maintainers = with maintainers; [ raskin rycee ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
