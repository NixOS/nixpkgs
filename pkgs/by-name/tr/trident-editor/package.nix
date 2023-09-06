{ lib, stdenv, ncurses5, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "trident-editor";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "LordOfTrident";
    repo = "trident-editor";
    rev = "v${version}";
    hash = "sha256-fOzBo7oEeOY4ccTClHGNgKIzE48QR+JDYWt3iYaUhl0=";
  };

  nativeBuildInputs = [ ncurses5 ];
  buildInputs = [ ncurses5 ];

  buildPhase = ''
    mkdir -p bin
    g++ -g src/*.cc -o bin/app -O3 -s -std=c++17 -lstdc++fs -lncursesw
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/app $out/bin/tr-ed
  '';

  meta = with lib; {
    description = "A free terminal text editor for Linux";
    homepage = "https://github.com/LordOfTrident/trident-editor";
    license = licenses.gpl3Only;
    mainProgram = "tr-ed";
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ arrie78 ];
  };
}
