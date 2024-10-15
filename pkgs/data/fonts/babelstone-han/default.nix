{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation {
  pname = "babelstone-han";
  version = "16.0.2";

  src = fetchzip {
    # upstream download links are unversioned, so hash changes
    url = "https://www.babelstone.co.uk/Fonts/Download/BabelStoneHan.zip";
    hash = "sha256-0yfp426zcyyf83wkh37dybaxd753ppz5c4wdfqrfnv6zqjp69dls";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Unicode CJK font with over 36000 Han characters";
    homepage = "https://www.babelstone.co.uk/Fonts/Han.html";

    license = licenses.arphicpl;
    platforms = platforms.all;
    maintainers = with maintainers; [ emily deeengan ];
  };
}
