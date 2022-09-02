{ lib, fetchFromGitHub, fetchpatch, buildDunePackage
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

  # Ensure compatibility with menhir ≥ 20211215
  patches = fetchpatch {
    url = "https://github.com/ocaml-toml/To.ml/commit/41172b739dff43424a12f7c1f0f64939e3660648.patch";
    sha256 = "sha256:1333xkmm9qp5m3pp4y5w17k6rvmb30v62qyra6rfk1km2v28hqqq";
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
