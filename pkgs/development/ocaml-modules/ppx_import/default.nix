{ lib, fetchFromGitHub, buildDunePackage, ocaml
, ounit, ppx_deriving, ppx_tools_versioned
}:

if !lib.versionAtLeast ocaml.version "4.04"
then throw "ppx_import is not available for OCaml ${ocaml.version}"
else

buildDunePackage rec {
  pname = "ppx_import";
  version = "1.5-3";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = "ppx_import";
    rev = "bd627d5afee597589761d6fee30359300b5e1d80";
    sha256 = "1f9bphif1izhyx72hvwpkd9kxi9lfvygaicy6nbxyp6qgc87z4nm";
  };

  buildInputs = [ ounit ppx_deriving ];
  propagatedBuildInputs = [ ppx_tools_versioned ];

  doCheck = true;
  checkTarget = "test";

  meta = {
    description = "A syntax extension that allows to pull in types or signatures from other compiled interface files";
    license = lib.licenses.mit;
    inherit (src.meta) homepage;
  };
}
