{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "crimson-pro";
  version = "unstable-2022-08-30";

  outputs = [
    "out"
    "woff2"
  ];

  src = fetchFromGitHub {
    owner = "Fonthausen";
    repo = "CrimsonPro";
    rev = "24e8f7bf59ec45d77c67879ad80d97e5f94c787b";
    hash = "sha256-3zFB1AMcC7eNEVA2Mx1OE8rLN9zPzexZ3FtER9wH5ss=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/truetype fonts/ttf/*.ttf
    install -m444 -Dt $out/share/fonts/opentype fonts/otf/*.otf
    install -m444 -Dt $woff2/share/fonts/woff2 fonts/webfonts/*.woff2

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/Fonthausen/CrimsonPro";
    description = "Professionally produced redesign of Crimson by Jacques Le Bailly";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ncfavier ];
  };
}
