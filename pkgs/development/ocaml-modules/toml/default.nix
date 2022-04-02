{ lib, fetchFromGitHub, buildDunePackage
, iso8601, menhir
}:

buildDunePackage rec {
  pname = "toml";
  version = "6.0.0";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "ocaml-toml";
    repo = "to.ml";
    rev = version;
    sha256 = "08ywzqckllvwawl1wpgg7qzvx6jhq7d6vysa0d5hj7qdwq213ggm";
  };

  nativeBuildInputs = [ menhir ];
  propagatedBuildInputs = [ iso8601 ];

  meta = {
    description = "Implementation in OCaml of the Toml minimal langage";
    homepage = "http://ocaml-toml.github.io/To.ml";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
