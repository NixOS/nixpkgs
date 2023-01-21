# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

let
  version = "unstable-2019-12-05";
  repo = "CourierPrime";
  rev = "7f6d46a766acd9391d899090de467c53fd9c9cb0";
in (fetchzip rec {
  name = "courier-prime-${version}";
  url = "https://github.com/quoteunquoteapps/${repo}/archive/${rev}/${name}.zip";
  sha256 = "1xh4pkksm6zrafhb69q4lq093q6pl245zi9qhqw3x6c1ab718704";

  meta = with lib; {
    description = "Monospaced font designed specifically for screenplays";
    homepage = "https://github.com/quoteunquoteapps/CourierPrime";
    license = licenses.ofl;
    maintainers = [ maintainers.austinbutler ];
    platforms = platforms.all;
  };
}).overrideAttrs (_: {
  postFetch = ''
    unzip $downloadedFile
    install -m444 -Dt $out/share/fonts/truetype ${repo}-${rev}/fonts/ttf/*.ttf
  '';
})
