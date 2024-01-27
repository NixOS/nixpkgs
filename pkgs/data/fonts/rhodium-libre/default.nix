{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "RhodiumLibre";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "DunwichType";
    repo = pname;
    rev = version;
    hash = "sha256-YCQvUdjEAj4G71WCRCM0+NwiqRqwt1Ggeg9jb/oWEsY=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/share/fonts/opentype/ RhodiumLibre-Regular.otf
    install -Dm444 -t $out/share/fonts/truetype/ RhodiumLibre-Regular.ttf

    runHook postInstall
  '';

  meta = with lib; {
    description = "F/OSS/Libre font for Latin and Devanagari";
    homepage = "https://github.com/DunwichType/RhodiumLibre";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
