{stdenv, fetchzip}:

let
  version = "11.0.2";
in fetchzip {
  name = "babelstone-han-${version}";

  url = http://www.babelstone.co.uk/Fonts/Download/BabelStoneHan.zip;
  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    unzip $downloadedFile '*.ttf' -d $out/share/fonts/truetype
  '';
  sha256 = "003cz520riskjp729y3piqhmnzfw3jyrmb94im7jyvlc7hp14cdh";

  meta = with stdenv.lib; {
    description = "Unicode CJK font with over 36000 Han characters";
    homepage = http://www.babelstone.co.uk/Fonts/Han.html;

    license = licenses.free;
    platforms = platforms.all;
    hydraPlatforms = [];
    maintainers = [ maintainers.volth ];
  };
}
