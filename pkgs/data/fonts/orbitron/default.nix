{ stdenv, fetchzip }:

let
  version = "20110526";
in fetchzip {
  name = "orbitron-${version}";

  url = https://github.com/theleagueof/orbitron/archive/13e6a52.zip;

  postFetch = ''
    otfdir=$out/share/fonts/opentype/orbitron
    ttfdir=$out/share/fonts/ttf/orbitron
    mkdir -p $otfdir $ttfdir
    unzip -j $downloadedFile \*/Orbitron\*.otf -d $otfdir
    unzip -j $downloadedFile \*/Orbitron\*.ttf -d $ttfdir
  '';

  sha256 = "1y9yzvpqs2v3ssnqk2iiglrh8amgsscnk8vmfgnqgqi9f4dhdvnv";

  meta = with stdenv.lib; {
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
