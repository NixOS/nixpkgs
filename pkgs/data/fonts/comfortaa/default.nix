{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "comfortaa";
  version = "unstable-2021-07-29";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = pname;
    rev = "2a87ac6f6ea3495150bfa00d0c0fb53dd0a2f11b";
    postFetch = ''
      # Remove the OTF fonts as they are not needed and cause a hash mismatch
      rm -rf $out/fonts/{OTF,otf}
    '';
    hash = "sha256-4ZBRaQyYlnt9l4NgBHezuCnR3rKTJ37L41RTbGAhd0M=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype $out/share/doc/comfortaa
    cp fonts/TTF/*.ttf $out/share/fonts/truetype
    cp FONTLOG.txt README.md $out/share/doc/comfortaa

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://aajohan.deviantart.com/art/Comfortaa-font-105395949";
    description = "A clean and modern font suitable for headings and logos";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
