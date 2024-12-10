{
  lib,
  buildDunePackage,
  fetchurl,
  ppxlib,
  alcotest,
  mdx,
  ppx_deriving,
  yaml,
}:

buildDunePackage rec {
  pname = "ppx_deriving_yaml";
  version = "0.2.2";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/patricoferris/ppx_deriving_yaml/releases/download/v${version}/ppx_deriving_yaml-${version}.tbz";
    hash = "sha256-9xy43jaCpKo/On5sTTt8f0Mytyjj1JN2QuFMcoWYTBY=";
  };

  propagatedBuildInputs = [
    ppxlib
    ppx_deriving
    yaml
  ];

  doCheck = true;
  checkInputs = [ alcotest ];
  nativeCheckInputs = [ mdx.bin ];

  meta = {
    description = "A YAML codec generator for OCaml";
    homepage = "https://github.com/patricoferris/ppx_deriving_yaml";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
}
