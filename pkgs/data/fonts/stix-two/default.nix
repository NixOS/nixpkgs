{ lib, fetchzip }:
let
  version = "2.12";
in
fetchzip {
  name = "stix-two-${version}";

  url = "https://github.com/stipub/stixfonts/raw/v${version}/zipfiles/STIX${builtins.replaceStrings [ "." ] [ "_" ] version}-all.zip";

  sha256 = "1a6v8p5zbjlv1gfhph0rzkvnmvxf4n1y0mdrdgng01yyl1nngrn9";

  postFetch = ''
    mkdir -p $out/share/fonts/
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
  '';

  meta = with lib; {
    homepage = "https://www.stixfonts.org/";
    description = "Fonts for Scientific and Technical Information eXchange";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
