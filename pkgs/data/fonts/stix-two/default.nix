{ lib, fetchzip }:
let
  version = "2.10";
in
fetchzip {
  name = "stix-two-${version}";

  url = "https://github.com/stipub/stixfonts/raw/v${version}/zipfiles/STIX${builtins.replaceStrings [ "." ] [ "_" ] version}-all.zip";

  sha256 = "1xvh5c5asbasfa333mizimvdp209g0lppbwv2p0cg3ixfpxgq4dl";

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
