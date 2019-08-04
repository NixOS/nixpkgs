{ stdenv, fetchFromGitHub, ocamlPackages, buildOasisPackage }:

buildOasisPackage rec {
  name = "tcslib";
  version = "v0.3";

  minimumSupportedOCamlVersion = "4.03.0";

  src = fetchFromGitHub {
    owner  = "tcsprojects";
    repo   = "tcslib";
    rev    = version;
    sha256 = "05g6m82blsccq8wx8knxv6a5fzww7hi624jx91f9h87nk2fsplhi";
  };

  buildInputs = with ocamlPackages; [ ounit ];
  propagatedBuildInputs = with ocamlPackages; [ ocaml_extlib num ];

  meta = {
    homepage = https://github.com/tcsprojects/tcslib;
    description = "A multi-purpose library for OCaml";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ mgttlinger ];
  };
}
