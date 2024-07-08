{ lib, buildDunePackage, fetchurl, ppxlib, alcotest, mdx
, ppx_deriving, yaml
}:

buildDunePackage rec {
  pname = "ppx_deriving_yaml";
  version = "0.3.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/patricoferris/ppx_deriving_yaml/releases/download/v${version}/ppx_deriving_yaml-${version}.tbz";
    hash = "sha256-HLY0ozmy6zY0KjXkwP3drTdz857PvLS/buN1nB+xf1s=";
  };

  propagatedBuildInputs = [ ppxlib ppx_deriving yaml ];

  doCheck = true;
  checkInputs = [ alcotest ];
  nativeCheckInputs = [ mdx.bin ];

  meta = {
    description = "YAML codec generator for OCaml";
    homepage = "https://github.com/patricoferris/ppx_deriving_yaml";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
}
