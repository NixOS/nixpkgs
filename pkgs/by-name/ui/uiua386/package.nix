{
  lib,
  stdenvNoCC,
  uiua,
}:

stdenvNoCC.mkDerivation {
  pname = "uiua386";

  inherit (uiua) src version;

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/share/fonts/truetype ./site/Uiua386.ttf

    runHook postInstall
  '';

  meta = {
    description = "Uiua font";
    homepage = "https://uiua.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ skykanin ];
    platforms = lib.platforms.all;
  };
}
