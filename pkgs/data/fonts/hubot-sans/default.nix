{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "hubot-sans";
  version = "1.0";

  src = fetchFromGitHub {
    rev = "v" + version;
    owner = "github";
    repo = pname;
    sha256 = "GOql+V5TH4b3TmhlgnKcx3jzUAO2jm4HRJRNzdIKxgg=";
  };

  installPhase = ''
    install -m644 --target $out/share/fonts/truetype/hubot-sans -D $src/dist/hubot-sans.ttf
  '';

  meta = {
    description = "A variable font from GitHub";
    homepage = "https://github.com/github/hubot-sans";
    license = lib.licenses.ofl;
    longDescription = ''
      Hubot Sans is Mona Sans’s robotic sidekick. The typeface is designed with
      more geometric accents to lend a technical and idiosyncratic feel—perfect
      for headers and pull-quotes. Made together with Degarism.

      Hubot Sans is a variable font. Variable fonts enable different variations
      of a typeface to be incorporated into one single file, and are supported
      by all major browsers.
    '';
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.all;
  };
}
