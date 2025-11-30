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

let
  param =
    if lib.versionAtLeast ppxlib.version "0.36" then
      {
        version = "0.4.1";
        hash = "sha256-3CvvMEOq/3I3WJ6X5EyopiaMjshZoEMPk2K4Lx0ldSo=";
      }
    else
      {
        version = "0.4.0";
        hash = "sha256-MVwCFAZY9Ui1gOckfbbj882w2aloHCGmJhpL1BDUEAg=";
      };
in

buildDunePackage rec {
  pname = "ppx_deriving_yaml";
  inherit (param) version;

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/patricoferris/ppx_deriving_yaml/releases/download/v${version}/ppx_deriving_yaml-${version}.tbz";
    inherit (param) hash;
  };

  propagatedBuildInputs = [
    ppxlib
    ppx_deriving
    yaml
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    mdx
  ];
  nativeCheckInputs = [ mdx.bin ];

  meta = {
    description = "YAML codec generator for OCaml";
    homepage = "https://github.com/patricoferris/ppx_deriving_yaml";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
}
