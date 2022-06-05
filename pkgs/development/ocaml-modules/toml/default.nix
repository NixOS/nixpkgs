{ lib, fetchFromGitHub, buildDunePackage
, iso8601, menhir
}:

buildDunePackage rec {
  pname = "toml";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "ocaml-toml";
    repo = "to.ml";
    rev = version;
    sha256 = "sha256-VEZQTFPwAGShCBGbKUiNOIY1zA/JdTpXU0ZIGNWopnQ=";
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
