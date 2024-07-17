{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "curie";
  version = "1.0";

  src = fetchurl {
    url = "https://github.com/NerdyPepper/curie/releases/download/v${version}/curie-v${version}.tar.gz";
    hash = "sha256-B89GNbOmm3lY/cRWQJEFu/5morCM/WrRQb/m6covbt8=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/misc
    install *.otb $out/share/fonts/misc

    runHook postInstall
  '';

  meta = with lib; {
    description = "An upscaled version of scientifica";
    homepage = "https://github.com/NerdyPepper/curie";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ moni ];
  };
}
