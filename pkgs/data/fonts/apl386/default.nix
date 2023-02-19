{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "apl386";
  version = "2022-03-07";

  src = fetchFromGitHub {
    owner = "abrudz";
    repo = "APL386";
    rev = "6332c9dbb588946a0e8c9d7984dd0c003eeea266";
    sha256 = "sha256-oHk4e7NRgAjGtZzQmZToYz7wCZETaj7/yRwZMeeYF2M=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 APL386.ttf -t $out/share/fonts/apl386

    runHook postInstall
  '';

  meta = with lib; {
    description = "APL385 Unicode font evolved ";
    homepage = "https://github.com/abrudz/APL386";
    license = licenses.unlicense;
    maintainers = with maintainers; [ buffet ];
    platforms = platforms.all;
  };
}
