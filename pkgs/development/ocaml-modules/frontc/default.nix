{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ocaml,
  menhir,
}:

buildDunePackage (finalAttrs: {
  pname = "FrontC";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "BinaryAnalysisPlatform";
    repo = "FrontC";
    rev = "v${finalAttrs.version}";
    sha256 = "1mi1vh4qgscnb470qwidccaqd068j1bqlz6pf6wddk21paliwnqb";
  };

  minimalOCamlVersion = "4.08";

  nativeBuildInputs = [ menhir ];

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    inherit (ocaml.meta) platforms;
    description = "C Parsing Library";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.maurer ];
  };
})
