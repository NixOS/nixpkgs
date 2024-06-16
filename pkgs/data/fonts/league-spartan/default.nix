{ lib, fetchzip, stdenvNoCC }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "league-spartan";
  version = "2.220";

  src = fetchzip {
    url = "https://github.com/theleagueof/league-spartan/releases/download/${finalAttrs.version}/LeagueSpartan-${finalAttrs.version}.tar.xz";
    hash = "sha256-dkvWRYli8vk+E0DkZ2NWCJKfSfdo4jEcGo0puQpFVVc=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/truetype $src/static/TTF/*.ttf
    install -D -m444 -t $out/share/fonts/opentype $src/static/OTF/*.otf

    runHook postInstall
  '';

  meta = {
    description = "A fantastic new revival of ATF's classic Spartan, a geometric sans-serif that has no problem kicking its enemies in the chest";
    longDescription = ''
      A new classic, this is a bold, modern, geometric sans-serif that has no
      problem kicking its enemies in the chest.

      Taking a strong influence from ATF's classic Spartan family, we're
      starting our own family out with a single strong weight. We've put a few
      unique touches into a beautiful, historical typeface, and made sure to
      include an extensive characterset – currently totaling over 300 glyphs.

      Over time, the open-source license will allow us expand League Spartan
      into a full family, with multiple weights and styles, and we're starting
      by releasing our first Bold style for this exciting, modern classic now.
    '';
    homepage = "https://www.theleagueofmoveabletype.com/league-spartan";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ minijackson ];
  };
})
