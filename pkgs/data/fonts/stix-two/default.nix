{ stdenv, fetchzip }:

let
  version = "2.0.0";
in fetchzip {
  name = "stix-two-${version}";

  url = "mirror://sourceforge/stixfonts/Current%20Release/STIXv${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "19i30d2xjk52bjj7xva1hnlyh58yd5phas1njcc8ldcz87a1lhql";

  meta = with stdenv.lib; {
    homepage = http://www.stixfonts.org/;
    description = "Fonts for Scientific and Technical Information eXchange";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
