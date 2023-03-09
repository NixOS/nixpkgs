{ lib, fetchzip, stdenvNoCC }:

stdenvNoCC.mkDerivation (self: {
  pname = "the-neue-black";
  version = "1.007";

  src = fetchzip {
    url = "https://github.com/theleagueof/the-neue-black/releases/download/${self.version}/TheNeueBlack-${self.version}.tar.xz";
    hash = "sha256-AsB6w1000xdl+pOPDXqqzQhru1T/VD0hIJ4gFec7mU4=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/truetype $src/static/TTF/*.ttf
    install -D -m444 -t $out/share/fonts/opentype $src/static/OTF/*.otf

    runHook postInstall
  '';

  meta = {
    description = "Tré Seals’ first open-source font, a typeface based on the Chicago Freedom Movement";
    longDescription = ''
      The open-source release of The Neue Black is in partnership with designer
      Tré Seals of Vocal Type Co. The Neue Black is a display sans serif with a
      robust character set that has over 25 ligatures and various inktrap
      alternates.
    '';
    homepage = "https://www.theleagueofmoveabletype.com/the-neue-black";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ minijackson ];
  };
})
