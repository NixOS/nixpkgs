{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "orbitron";
  version = "2011-05-25";

  src = fetchFromGitHub {
    owner = "theleagueof";
    repo = finalAttrs.pname;
    rev = "13e6a5222aa6818d81c9acd27edd701a2d744152";
    hash = "sha256-zjNPVrDUxcQbrsg1/8fFa6Wenu1yuG/XDfKA7NVZ0rA=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/truetype $src/*.ttf
    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.theleagueofmoveabletype.com/orbitron";
    downloadPage = "https://www.theleagueofmoveabletype.com/orbitron/download";
    description = "Geometric sans-serif for display purposes by Matt McInerney";
    longDescription = ''
      Orbitron is a geometric sans-serif typeface intended for display
      purposes. It features four weights (light, medium, bold, and
      black), a stylistic alternative, small caps, and a ton of
      alternate glyphs.

      Orbitron was designed so that graphic designers in the future
      will have some alternative to typefaces like Eurostile or Bank
      Gothic. If you’ve ever seen a futuristic sci-fi movie, you have
      may noticed that all other fonts have been lost or destroyed in
      the apocalypse that led humans to flee earth. Only those very few
      geometric typefaces have survived to be used on spaceship
      exteriors, space station signage, monopolistic corporate
      branding, uniforms featuring aerodynamic shoulder pads, etc. Of
      course Orbitron could also be used on the posters for the movies
      portraying this inevitable future.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with lib.maintainers; [
      leenaars
      minijackson
    ];
  };
})
