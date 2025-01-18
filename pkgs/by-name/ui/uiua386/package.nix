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

    install -Dm444 -t $out/share/fonts/truetype ./src/algorithm/Uiua386.ttf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Uiua font";
    homepage = "https://uiua.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ skykanin ];
    platforms = platforms.all;
  };
}
