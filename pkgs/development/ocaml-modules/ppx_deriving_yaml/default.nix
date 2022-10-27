{ lib, buildDunePackage, fetchurl, ppxlib, alcotest
, ppx_deriving, yaml
}:

buildDunePackage rec {
  pname = "ppx_deriving_yaml";
  version = "0.1.1";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/patricoferris/ppx_deriving_yaml/releases/download/v${version}/ppx_deriving_yaml-${version}.tbz";
    sha256 = "sha256-nR3568ULM6jaGG4H4+lLBTEJqh/ALHPiJxve40jPUxw=";
  };

  propagatedBuildInputs = [ ppxlib ppx_deriving yaml ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "A YAML codec generator for OCaml";
    homepage = "https://github.com/patricoferris/ppx_deriving_yaml";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
}
