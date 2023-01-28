# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

let
  pname = "national-park-typeface";
  version = "206464";
in (fetchzip {
  name = "${pname}-${version}";
  url = "https://files.cargocollective.com/c${version}/NationalPark.zip";

  sha256 = "044gh4xcasp8i9ny6z4nmns1am2pk5krc4ann2afq35v9bnl2q5d";

  meta = with lib; {
    description = ''Typeface designed to mimic the national park service
    signs that are carved using a router bit'';
    homepage = "https://nationalparktypeface.com/";
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile National\*.otf -d $out/share/fonts/opentype/
  '';
})
