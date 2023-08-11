{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lilex";
  version = "2.200";

  src = fetchzip {
    url = "https://github.com/mishamyrt/Lilex/releases/download/${finalAttrs.version}/Lilex.zip";
    hash = "sha256-MPQfqCMFMjcAlMos1o4bC+I+cvQYwr2TjI4Q03QeuaQ=";
    stripRoot = false;
  };


  installPhase = ''
    runHook preInstall

    install -Dm644 variable/*.ttf -t $out/share/fonts/lilex

    runHook postInstall
  '';

  meta = {
    description = "Open source programming font";
    homepage = "https://github.com/mishamyrt/Lilex";
    license = lib.licenses.ofl;
    longDescription = ''
      Lilex is the modern programming font containing a set of ligatures for
      common programming multi-character combinations.
    '';
    maintainers = with lib.maintainers; [ chriscoffee ];
    platforms = lib.platforms.all;
  };
})
