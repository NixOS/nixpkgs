{ lib, fetchFromGitHub }:

let
  version = "20110526";
in fetchFromGitHub {
  name = "orbitron-${version}";

  owner = "theleagueof";
  repo = "orbitron";
  rev = "13e6a52";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    install -m444 -Dt $out/share/fonts/opentype/orbitron *.otf
    install -m444 -Dt $out/share/fonts/ttf/orbitron      *.ttf
  '';

  sha256 = "1y9yzvpqs2v3ssnqk2iiglrh8amgsscnk8vmfgnqgqi9f4dhdvnv";

  meta = with lib; {
    homepage = https://www.theleagueofmoveabletype.com/orbitron;
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
