{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "mononoki";
  version = "1.5";

  src = fetchzip {
    url = "https://github.com/madmalik/mononoki/releases/download/${version}/mononoki.zip";
    stripRoot = false;
    hash = "sha256-H5Iu7nSrB5UGlCSjTM3SLu+IjaAffk9TCm5OoOleKvw=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/mononoki
    cp * $out/share/fonts/mononoki

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/madmalik/mononoki";
    description = "A font for programming and code review";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
