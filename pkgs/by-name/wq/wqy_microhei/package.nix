{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "wqy-microhei";
  version = "0.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/wqy/${pname}-${version}-beta.tar.gz";
    hash = "sha256-KAKsgCOqNqZupudEWFTjoHjTd///QhaTQb0jeHH3IT4=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 wqy-microhei.ttc $out/share/fonts/wqy-microhei.ttc

    runHook postInstall
  '';

  meta = {
    description = "(mainly) Chinese Unicode font";
    homepage = "http://wenq.org";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.pkmx ];
    platforms = lib.platforms.all;
  };
}
