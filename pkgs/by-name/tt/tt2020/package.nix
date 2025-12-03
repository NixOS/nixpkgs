{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "TT2020";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "ctrlcctrlv";
    repo = "TT2020";
    rev = "v${version}";
    hash = "sha256-eAJzaookHcQ/7QNq/HUKA/O2liyKynJNdo6QuZ1Bv6k=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/fonts/truetype dist/*.ttf
    install -Dm644 -t $out/share/fonts/woff2 dist/*.woff2

    runHook postInstall
  '';

  meta = with lib; {
    description = "Advanced, open source, hyperrealistic, multilingual typewriter font for a new decade";
    homepage = "https://ctrlcctrlv.github.io/TT2020";
    license = licenses.ofl;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.all;
  };
}
