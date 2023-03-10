{ lib, fetchzip, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "recursive";
  version = "1.085";

  src = fetchzip {
    url = "https://github.com/arrowtype/recursive/releases/download/v${version}/ArrowType-Recursive-${version}.zip";
    sha256 = "sha256-hnGnKnRoQN8vFStW8TjLrrTL1dWsthUEWxfaGF0b0vM=";
  };

  installPhase = ''
    install -D -t $out/share/fonts/opentype/ $(find $src -type f -name '*.otf')
    install -D -t $out/share/fonts/truetype/ $(find $src -type f -name '*.ttf')
  '';


  meta = with lib; {
    homepage = "https://recursive.design/";
    description = "A variable font family for code & UI";
    license = licenses.ofl;
    maintainers = [ maintainers.eadwu ];
    platforms = platforms.all;
  };
}
