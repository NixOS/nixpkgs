{ stdenv, fetchzip }:

let
  version = "1.2";
  pname = "norwester";
in fetchzip rec {
  name = "${pname}-${version}";

  url = "http://jamiewilson.io/norwester/assets/norwester.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    unzip -D -j $downloadedFile ${pname}-v${version}/${pname}.otf -d $out/share/fonts/opentype/
  '';

  sha256 = "1npsaiiz9g5z6315lnmynwcnrfl37fyxc7w1mhkw1xbzcnv74z4r";

  meta = with stdenv.lib; {
    homepage = http://jamiewilson.io/norwester;
    description = "A condensed geometric sans serif by Jamie Wilson";
    maintainers = with maintainers; [ leenaars ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
