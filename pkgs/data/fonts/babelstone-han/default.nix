{stdenv, fetchzip}:

let
  version = "10.0.2";
in fetchzip {
  name = "babelstone-han-${version}";

  url = http://www.babelstone.co.uk/Fonts/7932/BabelStoneHan.zip;
  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    unzip $downloadedFile '*.ttf' -d $out/share/fonts/truetype
  '';
  sha256 = "17r5cf028v66yzjf9qbncn4rchv2xxkl2adxr35ppg1l7zssz9v6";

  meta = with stdenv.lib; {
    description = "Unicode CJK font with over 32600 Han characters";
    homepage = http://www.babelstone.co.uk/Fonts/Han.html;

    license = licenses.free;
    platforms = platforms.all;
    hydraPlatforms = [];
    maintainers = [ maintainers.volth ];
  };
}
