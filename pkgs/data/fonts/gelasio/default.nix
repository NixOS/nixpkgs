{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "gelasio";
  version = "unstable-2022-06-09";

  src = fetchFromGitHub {
    owner = "SorkinType";
    repo = "Gelasio";
    rev = "a75c6d30a35f74cdbaea1813bdbcdb64bb11d3d5";
    hash = "sha256-ncm0lSDPPPREdxTx3dGl6OGBn4FGAjFTlQpA6oDCdMI=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp fonts/ttf/*.ttf $out/share/fonts/truetype/

    runHook postInstall
  '';

  meta = with lib; {
    description = "a font which is metric-compatible with Microsoft's Georgia";
    longDescription = ''
      Gelasio is an original typeface which is metrics compatible with Microsoft's
      Georgia in its Regular, Bold, Italic and Bold Italic weights. Interpolated
      Medium, medium Italic, SemiBold and SemiBold Italic have now been added as well.
    '';
    homepage = "https://github.com/SorkinType/Gelasio";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ colemickens ];
  };
}
