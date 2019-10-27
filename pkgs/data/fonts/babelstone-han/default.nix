{ lib, fetchzip }:

let
  version = "12.1.4";
in fetchzip {
  name = "babelstone-han-${version}";

  url = http://www.babelstone.co.uk/Fonts/Download/BabelStoneHan.zip;
  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    unzip $downloadedFile '*.ttf' -d $out/share/fonts/truetype
  '';
  sha256 = "1fypwk2i87jfrckvxg9wz4x84z7c6ifgzrjb8fylhac50lzi6kni";

  meta = with lib; {
    description = "Unicode CJK font with over 36000 Han characters";
    homepage = http://www.babelstone.co.uk/Fonts/Han.html;

    license = licenses.free;
    platforms = platforms.all;
    hydraPlatforms = [];
    maintainers = [ maintainers.volth ];
  };
}
