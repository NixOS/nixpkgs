{
  lib,
  stdenv,
  fetchFromGitHub,
  tt-rss,
}:

stdenv.mkDerivation {
  pname = "tt-rss-plugin-af-readability";
  version = "unstable-2025-10-16";

  src = fetchFromGitHub {
    owner = "tt-rss";
    repo = "tt-rss-plugin-af-readability";
    rev = "fce528aa69c2a7193fb7eb3a3cd9dd17885d6ab6";
    hash = "sha256-3rxrICtm6+ujlBHj5Su2sSEq3lgiHhQMJ/OVfzhzYXA=";
  };

  installPhase = ''
    mkdir -p $out/af_readability

    cp -a * $out/af_readability/
  '';

  meta = {
    description = "Plugin for TT-RSS to inline article content using Readability";
    license = lib.licenses.gpl3;
    homepage = "https://github.com/tt-rss/tt-rss-plugin-af-readability/";
    maintainers = with lib.maintainers; [ gdamjan ];
    inherit (tt-rss.meta) platforms;
  };
}
