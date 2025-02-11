{
  lib,
  stdenv,
  fetchFromGitHub,
  ...
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vt323";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "phoikoi";
    repo = "VT323";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Abq0/hU/BXJMxQxzhZG1SEGIZYt+qofuXwy5/A9byQ8=";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp fonts/ttf/VT323-Regular.ttf $out/share/fonts/truetype
  '';

  meta = {
    changelog = "https://github.com/phoikoi/VT323/releases/tag/v${finalAttrs.version}";
    description = "Monospaced typeface designed to look like the VT320 text terminal glyphs";
    homepage = "https://github.com/phoikoi/VT323";
    license = with lib.licenses; [ ofl ];
    maintainers = with lib.maintainers; [ marcel ];
  };
})
