{ lib, fetchFromGitHub, buildDunePackage
, iso8601, menhir
}:

buildDunePackage rec {
  pname = "toml";
  version = "5.0.0";
  src = fetchFromGitHub {
    owner = "ocaml-toml";
    repo = "to.ml";
    rev = "v${version}";
    sha256 = "1505kwcwklcfaxw8wckajm8kc6yrlikmxyhi8f8cpvhlw9ys90nj";
  };

  buildInputs = [ menhir ];
  propagatedBuildInputs = [ iso8601 ];

  meta = {
    description = "Implementation in OCaml of the Toml minimal langage";
    homepage = "http://ocaml-toml.github.io/To.ml";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
