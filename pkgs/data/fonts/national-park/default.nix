{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "national-park-typeface";
  version = "206464";

  src = fetchzip {
    url = "https://files.cargocollective.com/c${version}/NationalPark.zip";
    stripRoot = false;
    hash = "sha256-VUboZZVJfKupnoHXo3RxetEEYimrr1DxghVZaaWnnw4=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.otf -t $out/share/fonts/opentype/

    runHook postInstall
  '';

  meta = with lib; {
    description = ''
      Typeface designed to mimic the national park service
          signs that are carved using a router bit'';
    homepage = "https://nationalparktypeface.com/";
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
  };
}
