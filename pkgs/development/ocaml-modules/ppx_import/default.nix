{ lib, fetchurl, buildDunePackage, ocaml
, ounit, ppx_deriving, ppx_tools_versioned
}:

if !lib.versionAtLeast ocaml.version "4.04"
then throw "ppx_import is not available for OCaml ${ocaml.version}"
else

buildDunePackage rec {
  pname = "ppx_import";
  version = "1.7.1";

  src = fetchurl {
    url = "https://github.com/ocaml-ppx/ppx_import/releases/download/v${version}/ppx_import-v${version}.tbz";
    sha256 = "16dyxfb7syz659rqa7yq36ny5vzl7gkqd7f4m6qm2zkjc1gc8j4v";
  };

  buildInputs = [ ounit ppx_deriving ];
  propagatedBuildInputs = [ ppx_tools_versioned ];

  doCheck = true;

  meta = {
    description = "A syntax extension that allows to pull in types or signatures from other compiled interface files";
    license = lib.licenses.mit;
    homepage = "https://github.com/ocaml-ppx/ppx_import";
  };
}
