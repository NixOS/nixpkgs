{ lib, stdenv, fetchzip }:

stdenv.mkDerivation (attrs: {
  pname = "Alice";
  version = "2.003";

  outputs = [ "out" "woff2" ];

  src = fetchzip {
    url = with attrs; "https://github.com/cyrealtype/${pname}/releases/download/v${version}/${pname}-v${version}.zip";
    stripRoot = false;
    hash = "sha256-p+tE3DECfJyBIPyafGZ8jDYQ1lPb+iAnEwLyaUy7DW0=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/truetype fonts/ttf/*.ttf
    install -m444 -Dt $out/share/fonts/opentype fonts/otf/*.otf
    install -m444 -Dt $woff2/share/fonts/woff2 fonts/webfonts/*.woff2

    runHook postInstall
  '';

  meta = with lib; {
    description = "Open-source font by Ksenia Erulevich";
    homepage = "https://github.com/cyrealtype/Alice";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ncfavier ];
  };
})
