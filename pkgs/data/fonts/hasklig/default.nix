# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

let
  version = "1.1";
in (fetchzip {
  name = "hasklig-${version}";

  url = "https://github.com/i-tu/Hasklig/releases/download/${version}/Hasklig-${version}.zip";

  sha256 = "0xxyx0nkapviqaqmf3b610nq17k20afirvc72l32pfspsbxz8ybq";

  meta = with lib; {
    homepage = "https://github.com/i-tu/Hasklig";
    description = "A font with ligatures for Haskell code based off Source Code Pro";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ davidrusu Profpatsch ];
  };
}).overrideAttrs (_: {
  postFetch = ''
    unzip $downloadedFile
    install -m444 -Dt $out/share/fonts/opentype *.otf
  '';
})
