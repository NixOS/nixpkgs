{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sniglet";
  version = "2011-05-25";

  src = fetchFromGitHub {
    owner = "theleagueof";
    repo = finalAttrs.pname;
    rev = "5c6b0860bdd0d8c4f16222e4de3918c384db17c4";
    hash = "sha256-fLT2hZT9o1Ka30EB/6oWwmalhVJ+swXLRFG99yRWd2c=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/truetype $src/*.ttf
    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = {
    description = "A fun rounded display face that’s great for headlines";
    longDescription = ''
      A rounded display face that’s great for headlines. It comes with a full
      character set, so you can type in Icelandic or even French!
    '';
    homepage = "https://www.theleagueofmoveabletype.com/sniglet";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ minijackson ];
  };
})
