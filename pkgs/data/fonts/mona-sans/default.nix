{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "mona-sans";
  version = "1.0";

  src = fetchFromGitHub {
    rev = "v" + version;
    owner = "github";
    repo = pname;
    sha256 = "iJhbSGNByOvtJd9hEh0g7Ht6eoAJ18jco0oHGqjOiLQ=";
  };

  installPhase = ''
    install -m644 --target $out/share/fonts/truetype/mona-sans -D $src/dist/*.ttf
  '';

  meta = {
    description = "A variable font from GitHub";
    homepage = "https://github.com/github/mona-sans";
    license = lib.licenses.ofl;
    longDescription = ''
      A strong and versatile typeface, designed together with Degarism and
      inspired by industrial-era grotesques. Mona Sans works well across
      product, web, and print. Made to work well together with Mona Sans's
      sidekick, Hubot Sans.

      Mona Sans is a variable font. Variable fonts enable different variations
      of a typeface to be incorporated into one single file, and are supported
      by all major browsers, allowing for performance benefits and granular
      design control of the typeface's weight, width, and slant.
    '';
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.all;
  };
}
