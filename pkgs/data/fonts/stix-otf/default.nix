{ lib, fetchzip }:

let
  version = "1.1.1";
in fetchzip rec {
  name = "stix-otf-${version}";

  url = "http://ftp.fi.muni.cz/pub/linux/gentoo/distfiles/STIXv${version}-word.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "04d4qxq3i9fyapsmxk6d9v1xirjam8c74fyxs6n24d3gf2945zmw";

  meta = with lib; {
    homepage = http://www.stixfonts.org/;
    description = "Fonts for Scientific and Technical Information eXchange";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
