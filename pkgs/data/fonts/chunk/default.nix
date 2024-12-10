{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "chunk";
  version = "2021-03-03";

  src = fetchFromGitHub {
    owner = "theleagueof";
    repo = finalAttrs.pname;
    rev = "12a243f3fb7c7a68844901023f7d95d6eaf14104";
    hash = "sha256-NMkRvrUgy9yzOT3a1rN6Ch/p8Cr902CwL4G0w7jVm1E=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/truetype $src/*.ttf
    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = {
    description = "An ultra-bold, ultra-awesome slab serif typeface";
    longDescription = ''
      Chunk is an ultra-bold slab serif typeface that is reminiscent of old
      American Western woodcuts, broadsides, and newspaper headlines. Used
      mainly for display, the fat block lettering is unreserved yet refined for
      contemporary use.

      In 2014, a new textured style was created by Tyler Finck called Chunk
      Five Print. It contains the same glyphs as the original.
    '';
    homepage = "https://www.theleagueofmoveabletype.com/chunk";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ minijackson ];
  };
})
