# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

let
  version = "1.2";
  pname = "norwester";
in (fetchzip {
  name = "${pname}-${version}";

  url = "http://jamiewilson.io/norwester/assets/norwester.zip";

  sha256 = "1npsaiiz9g5z6315lnmynwcnrfl37fyxc7w1mhkw1xbzcnv74z4r";

  meta = with lib; {
    homepage = "http://jamiewilson.io/norwester";
    description = "A condensed geometric sans serif by Jamie Wilson";
    maintainers = with maintainers; [ leenaars ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    unzip -D -j $downloadedFile ${pname}-v${version}/${pname}.otf -d $out/share/fonts/opentype/
  '';
})
