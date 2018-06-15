{stdenv, fetchzip}:

let
  version = "1.1";
in fetchzip rec {
  name = "quattrocento-${version}";

  url = "http://www.impallari.com/media/releases/quattrocento-v${version}.zip";

  postFetch = ''
    mkdir -p $out/share/{fonts,doc}
    unzip -j $downloadedFile \*.otf        -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*FONTLOG.txt -d $out/share/doc/${name}
  '';

  sha256 = "0f8l19y61y20sszn8ni8h9kgl0zy1gyzychg22z5k93ip4h7kfd0";

  meta = with stdenv.lib; {
    homepage = http://www.impallari.com/quattrocento/;
    description = "A classic, elegant, sober and strong serif typeface";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
