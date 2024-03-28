{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "zed-sans";
  version = "1.2.0";

  src = fetchzip {
    url = "https://github.com/zed-industries/zed-fonts/releases/download/${version}/zed-sans-${version}.zip";
    stripRoot = false;
    hash = "sha256-BF18dD0UE8Q4oDEcCf/mBkbmP6vCcB2vAodW6t+tocs=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "The Zed Sans typeface, custom built from Iosevka";
    homepage = "https://github.com/zed-industries/zed-fonts";
    license = licenses.ofl;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
