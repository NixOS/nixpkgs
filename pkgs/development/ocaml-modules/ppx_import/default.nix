{ lib, fetchurl, buildDunePackage
, ppx_tools_versioned
, ocaml-migrate-parsetree
}:

buildDunePackage rec {
  pname = "ppx_import";
  version = "1.8.0";

  useDune2 = true;

  minimumOCamlVersion = "4.04";

  src = fetchurl {
    url = "https://github.com/ocaml-ppx/ppx_import/releases/download/v${version}/ppx_import-${version}.tbz";
    sha256 = "0zqcj70yyp4ik4jc6jz3qs2xhb94vxc6yq9ij0d5cyak28klc3gv";
  };

  propagatedBuildInputs = [
    ppx_tools_versioned ocaml-migrate-parsetree
  ];

  meta = {
    description = "A syntax extension that allows to pull in types or signatures from other compiled interface files";
    license = lib.licenses.mit;
    homepage = "https://github.com/ocaml-ppx/ppx_import";
  };
}
