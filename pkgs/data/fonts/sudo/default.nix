{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "sudo-font";
  version = "0.64";

  src = fetchzip {
    url = "https://github.com/jenskutilek/sudo-font/releases/download/v${version}/sudo.zip";
    hash = "sha256-Y99YPoNpe55Wrj5epiqqQ6ddUBTj9uI4oj4M5ARTzJo=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Font for programmers and command line users";
    homepage = "https://www.kutilek.de/sudo-font/";
    changelog = "https://github.com/jenskutilek/sudo-font/raw/v${version}/sudo/FONTLOG.txt";
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
