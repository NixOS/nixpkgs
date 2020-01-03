{ lib, fetchzip }:

let
  version = "12.1.7";
in fetchzip {
  name = "babelstone-han-${version}";

  url = https://www.babelstone.co.uk/Fonts/Download/BabelStoneHan.zip;
  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    unzip $downloadedFile '*.ttf' -d $out/share/fonts/truetype
  '';
  sha256 = "07liv0lmk28ybxccf91gp2wmc17pk3fcshixpj0jx069b64zwf1v";

  meta = with lib; {
    description = "Unicode CJK font with over 36000 Han characters";
    homepage = https://www.babelstone.co.uk/Fonts/Han.html;

    license = licenses.free;
    platforms = platforms.all;
    hydraPlatforms = [];
    maintainers = [ maintainers.volth ];
  };
}
