{stdenv, fetchurl, unzip}:

let
  version = "10.0.0";
in fetchurl {
  name = "babelstone-han-${version}";

  url = http://www.babelstone.co.uk/Fonts/0816/BabelStoneHan.zip;
  downloadToTemp = true;
  postFetch = ''
    ${unzip}/bin/unzip $downloadedFile
    mkdir -p $out/share/fonts/truetype
    cp -v *.ttf $out/share/fonts/truetype
  '';
  recursiveHash = true;
  sha256 = "0648hv5c1hq3bq7mlk7bnmflzzqj4wh137bjqyrwj5hy3nqzvl5r";

  meta = with stdenv.lib; {
    description = "Unicode CJK font with over 32600 Han characters";
    homepage = http://www.babelstone.co.uk/Fonts/Han.html;

    license = licenses.free;
    platforms = platforms.all;
    hydraPlatforms = [];
    maintainers = [ maintainers.volth ];
  };
}
