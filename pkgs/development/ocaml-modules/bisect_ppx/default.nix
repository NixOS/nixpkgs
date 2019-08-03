{ stdenv, fetchFromGitHub, buildDunePackage, ocaml-migrate-parsetree, ppx_tools_versioned }:

buildDunePackage rec {
  pname = "bisect_ppx";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "aantron";
    repo = "bisect_ppx";
    rev = version;
    sha256 = "1plhm4pvrhpapz5zaks194ji1fgzmp13y942g10pbn9m7kgkqg4h";
  };

  buildInputs = [
    ocaml-migrate-parsetree
    ppx_tools_versioned
  ];

  meta = {
    description = "Code coverage for OCaml";
    license = stdenv.lib.licenses.mpl20;
    homepage = https://github.com/aantron/bisect_ppx;
  };
}
