{stdenv, fetchzip}:

let
  version = "11.0.3";
in fetchzip {
  name = "babelstone-han-${version}";

  url = http://www.babelstone.co.uk/Fonts/Download/BabelStoneHan.zip;
  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    unzip $downloadedFile '*.ttf' -d $out/share/fonts/truetype
  '';
  sha256 = "0c8s21kllyilwivrb8gywq818y67w3zpann34hz36vy0wyiswn1c";

  meta = with stdenv.lib; {
    description = "Unicode CJK font with over 36000 Han characters";
    homepage = http://www.babelstone.co.uk/Fonts/Han.html;

    license = licenses.free;
    platforms = platforms.all;
    hydraPlatforms = [];
    maintainers = [ maintainers.volth ];
  };
}
