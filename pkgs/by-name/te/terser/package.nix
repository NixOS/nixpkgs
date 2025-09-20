{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage rec {
  pname = "terser";
  version = "5.38.0";

  src = fetchFromGitHub {
    owner = "terser";
    repo = "terser";
    rev = "v${version}";
    hash = "sha256-iVl5L5qxpXkBfiW8OqsMr4iZ0UQiN4TSAYXz9d29bnA=";
  };

  npmDepsHash = "sha256-84MWjkiv1/W+JyUtrjY9Rk0UIkZWIv07Q1qLSVYNcO4=";

  meta = {
    description = "JavaScript parser, mangler and compressor toolkit for ES6+";
    mainProgram = "terser";
    homepage = "https://terser.org";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ talyz ];
  };
}
