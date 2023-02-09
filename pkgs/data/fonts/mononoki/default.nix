{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "mononoki";
  version = "1.3";

  src = fetchzip {
    url = "https://github.com/madmalik/mononoki/releases/download/${version}/mononoki.zip";
    stripRoot = false;
    hash = "sha256-bZYBRdmbQVs4i6UzMIHwJnoLWggX4CW8ZogNFYiX/9w=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/mononoki
    cp webfont/* $out/share/fonts/mononoki

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/madmalik/mononoki";
    description = "A font for programming and code review";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
