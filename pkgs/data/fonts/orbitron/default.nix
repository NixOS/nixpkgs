{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "orbitron-${version}";
  version = "20110526";

  src = fetchFromGitHub {
    owner  = "theleagueof";
    repo   = "orbitron";
    rev    = "13e6a52";
    sha256 = "1c6jb7ayr07j1pbnzf3jxng9x9bbqp3zydf8mqdw9ifln1b4ycyf";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    otfdir=$out/share/fonts/opentype/orbitron
    ttfdir=$out/share/fonts/ttf/orbitron
    mkdir -p $otfdir $ttfdir
    cp -v Orbitron*.otf $otfdir
    cp -v Orbitron*.ttf $ttfdir
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.theleagueofmoveabletype.com/orbitron";
    downloadPage = "https://www.theleagueofmoveabletype.com/orbitron/download";
    description = ''
     Geometric sans-serif for display purposes by Matt McInerney'';
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
    maintainers = [ maintainers.leenaars ];
  };
}
