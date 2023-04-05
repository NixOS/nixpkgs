{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "manrope";
  version = "3";

  src = fetchFromGitHub {
    owner = "sharanda";
    repo = pname;
    rev = "3bd68c0c325861e32704470a90dfc1868a5c37e9";
    hash = "sha256-Gm7mUD/Ud2Rf8mA3jwUL7RE8clCmb6SETOskuj6r1sw=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/fonts/opentype "desktop font"/*

    runHook postInstall
  '';

  meta = with lib; {
    description = "Open-source modern sans-serif font family";
    homepage = "https://github.com/sharanda/manrope";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
