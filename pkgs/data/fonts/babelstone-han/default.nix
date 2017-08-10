{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "babelstone-han-${version}";
  version = "10.0.0";

  src = fetchurl {
    url = http://www.babelstone.co.uk/Fonts/0816/BabelStoneHan.zip;
    sha256 = "1vccpyk5fd35fq2mk48cdhzy5q6id1pzlski1knsiqamvyys4ykd";
  };

  buildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -v *.ttf $out/share/fonts/truetype
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "0648hv5c1hq3bq7mlk7bnmflzzqj4wh137bjqyrwj5hy3nqzvl5r";

  meta = with stdenv.lib; {
    description = "Unicode CJK font with over 32600 Han characters";
    homepage = http://www.babelstone.co.uk/Fonts/Han.html;

    license = licenses.free;
    platforms = platforms.all;
    hydraPlatforms = [];
    maintainers = [ maintainers.volth ];
  };
}
