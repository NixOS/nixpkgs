{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "apl386";
  version = "unstable-2022-03-07";

  src = fetchFromGitHub {
    owner = "abrudz";
    repo = "APL386";
    rev = "6332c9dbb588946a0e8c9d7984dd0c003eeea266";
    hash = "sha256-oHk4e7NRgAjGtZzQmZToYz7wCZETaj7/yRwZMeeYF2M=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/share/fonts/truetype *.ttf

    runHook postInstall
  '';

  meta = {
    homepage = "https://abrudz.github.io/APL386/";
    description = "APL385 Unicode font evolved";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
}
