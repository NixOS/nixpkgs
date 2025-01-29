{ lib, fetchFromGitHub, buildDunePackage
, stdlib-shims
}:

buildDunePackage rec {
  version = "3.0.0";
  pname = "earley";
  src = fetchFromGitHub {
    owner = "rlepigre";
    repo = "ocaml-earley";
    rev = version;
    sha256 = "1vi58zdxchpw6ai0bz9h2ggcmg8kv57yk6qbx82lh47s5wb3mz5y";
  };

  minimalOCamlVersion = "4.07";
  useDune2 = true;

  buildInputs = [ stdlib-shims ];

  doCheck = true;

  meta = {
    description = "Parser combinators based on Earley Algorithm";
    homepage = "https://github.com/rlepigre/ocaml-earley";
    license = lib.licenses.cecill-b;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "pa_ocaml";
  };
}
