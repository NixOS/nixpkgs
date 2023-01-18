# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ fetchzip, lib }:

let
  version = "1.1";
  pname = "HyperScrypt";
in

(fetchzip {
  name = "${lib.toLower pname}-font-${version}";
  url = "https://gitlab.com/StudioTriple/Hyper-Scrypt/-/archive/${version}/Hyper-Scrypt-${version}.zip";
  sha256 = "01pf5p2scmw02s0gxnibiwxbpzczphaaapv0v4s7svk9aw2gmc0m";

  meta = with lib; {
    homepage = "http://velvetyne.fr/fonts/hyper-scrypt/";
    description = "A modern stencil typeface inspired by stained glass technique";
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
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/fonts/{truetype,opentype}
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype/${pname}.ttf
    unzip -j $downloadedFile \*${pname}.otf -d $out/share/fonts/opentype/${pname}.otf
  '';
})
