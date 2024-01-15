{ lib, buildDunePackage, fetchFromGitHub, ocaml, menhir }:

buildDunePackage rec {
  pname = "FrontC";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "BinaryAnalysisPlatform";
    repo = "FrontC";
    rev = "v${version}";
    sha256 = "1mi1vh4qgscnb470qwidccaqd068j1bqlz6pf6wddk21paliwnqb";
  };

  minimalOCamlVersion = "4.08";

  nativeBuildInputs = [ menhir ];

  meta = with lib; {
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
    description = "C Parsing Library";
    license = licenses.lgpl21;
    maintainers = [ maintainers.maurer ];
  };
}
