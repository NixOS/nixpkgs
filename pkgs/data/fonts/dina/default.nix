{ stdenv, fetchzip }:

let
  version = "2.92";
in fetchzip rec {
  name = "dina-font-${version}";

  # `meta.homepage` has no direct download link
  url = "https://github.com/ProgrammingFonts/ProgrammingFonts/archive/b15ef365146be7eef4a46979cfe157c5aeefb7c0.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile '*/Dina/*.bdf' -d $out/share/fonts
    chmod u-x $out/share/fonts/*
  '';

  sha256 = "02a6hqbq18sw69npylfskriqhvj1nsk65hjjyd05nl913ycc6jl7";

  meta = with stdenv.lib; {
    description = "A monospace bitmap font aimed at programmers";
    longDescription = ''
      Dina is a monospace bitmap font, primarily aimed at programmers. It is
      relatively compact to allow a lot of code on screen, while (hopefully)
      clear enough to remain readable even at high resolutions.
    '';
    homepage = https://www.donationcoder.com/Software/Jibz/Dina/;
    downloadPage = https://www.donationcoder.com/Software/Jibz/Dina/;
    license = licenses.free;
    maintainers = [ maintainers.prikhi ];
  };
}
