{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "lilex";
  version = "2.200";

  src = fetchzip {
    url = "https://github.com/mishamyrt/Lilex/releases/download/${version}/Lilex.zip";
    sha256 = "sha256-MPQfqCMFMjcAlMos1o4bC+I+cvQYwr2TjI4Q03QeuaQ=";
    stripRoot = false;
  };


  installPhase = ''
    runHook preInstall

    install -Dm644 variable/*.ttf -t $out/share/fonts/lilex

    runHook postInstall
  '';

  meta = {
    description = "Open source programming font";
    longDescription = ''
      Lilex is the modern programming font containing a set of ligatures for
      common programming multi-character combinations.
    '';
    homepage = "https://github.com/mishamyrt/Lilex";

    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ chriscoffee ];
    platforms = lib.platforms; all;
  };
}
