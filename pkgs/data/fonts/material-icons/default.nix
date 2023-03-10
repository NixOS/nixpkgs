{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "material-icons";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "material-design-icons";
    rev = version;
    hash = "sha256-4FphNJCsaLWzlVR4TmXnDBid0EVj39fkeoh5j1leBZ8=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp iconfont/*.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "System status icons by Google, featuring material design";
    homepage = "https://material.io/icons";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ mpcsh ];
  };
}
