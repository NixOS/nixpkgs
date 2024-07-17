{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "hyperscrypt";
  version = "1.1";

  src = fetchzip {
    url = "https://gitlab.com/StudioTriple/Hyper-Scrypt/-/archive/${version}/Hyper-Scrypt-${version}.zip";
    hash = "sha256-ONlAB9C/GYK6KmOaiHCYErkS6OlQ3TUnoumNDHGZnes=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 fonts/HyperScrypt_Web/*.ttf -t $out/share/fonts/truetype/
    install -Dm644 fonts/HyperScrypt_Web/*.otf fonts/*.otf -t $out/share/fonts/opentype/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://velvetyne.fr/fonts/hyper-scrypt/";
    description = "Modern stencil typeface inspired by stained glass technique";
    longDescription = ''
      The Hyper Scrypt typeface was designed for the Hyper Chapelle
      exhibition. It was commissioned by AAAAA Atelier to Studio
      Triple's designer Jérémy Landes.  Hyper Scrypt is a modern
      stencil typeface inspired by the stained glass technique used in
      the Metz cathedral. It borrows the stained glass method, drawing
      holes for the light with black lead. This creates a reverse
      typeface, where the shapes of the letters are drawn by their
      counters. Hyper Scrypt is at the intersection between 3 metals :
      the sacred lead of stained glass, the lead of print characters
      and the heavy metal. Despite its organic look inherited for the
      molted metal, Hyper Scrypt is based upon a rigorous grid,
      allowing some neat alignements between shapes in multi lines
      layouts.
    '';
    license = licenses.ofl;
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.all;
  };
}
