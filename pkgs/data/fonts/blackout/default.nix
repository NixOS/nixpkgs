{ lib, fetchFromGitHub, stdenvNoCC }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "blackout";
  version = "2014-07-29";

  src = fetchFromGitHub {
    owner = "theleagueof";
    repo = finalAttrs.pname;
    rev = "4864cfc1749590e9f78549c6e57116fe98480c0f";
    hash = "sha256-UmJVmtuPQYW/w+mdnJw9Ql4R1xf/07l+/Ky1wX9WKqw=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/truetype $src/*.ttf

    runHook postInstall
  '';

  meta = {
    description = "Bad-ass, unholy-mother-shut-your-mouth stencil sans-serif";
    longDescription = ''
      Eats holes for breakfast lunch and dinner. Inspired by filling in
      sans-serif newspaper headlines. Continually updated with coffee and
      music. Makes your work louder than the next person’s.

      Comes in three styles: Midnight (solid), 2AM (reversed), & Sunrise
      (stroked).
    '';
    homepage = "https://www.theleagueofmoveabletype.com/blackout";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ minijackson ];
  };
})
