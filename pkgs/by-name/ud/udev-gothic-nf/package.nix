{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "udev-gothic-nf";
  version = "2.1.0";

  src = fetchzip {
    url = "https://github.com/yuru7/udev-gothic/releases/download/v${version}/UDEVGothic_NF_v${version}.zip";
    hash = "sha256-55SHOQD+6eJ2L3+95eofr18fp1nFeBKcZvZq8gfj7rA=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm644 *.ttf -t $out/share/fonts/udev-gothic-nf
    runHook postInstall
  '';

  meta = with lib; {
    description = "Programming font that combines BIZ UD Gothic, JetBrains Mono and nerd-fonts";
    homepage = "https://github.com/yuru7/udev-gothic";
    license = licenses.ofl;
    maintainers = with maintainers; [ haruki7049 ];
    platforms = platforms.all;
  };
}
