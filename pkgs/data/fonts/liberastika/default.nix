{stdenv, fetchzip}:

let
  version = "1.1.5";
in fetchzip rec {
  name = "liberastika-${version}";

  url = "mirror://sourceforge/project/lib-ka/liberastika-ttf-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/{doc,fonts}
    unzip -j $downloadedFile \*.ttf                           -d $out/share/fonts/truetype
    unzip -j $downloadedFile AUTHORS ChangeLog COPYING README -d "$out/share/doc/${name}"
  '';

  sha256 = "1a9dvl1pzch2vh8sqyyn1d1wz4n624ffazl6hzlc3s5k5lzrb6jp";

  meta = with stdenv.lib; {
    description = "Liberation Sans fork with improved cyrillic support";
    homepage = https://sourceforge.net/projects/lib-ka/;

    license = licenses.gpl2;
    platforms = platforms.all;
    hydraPlatforms = [];
    maintainers = [ maintainers.volth ];
  };
}
