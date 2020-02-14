{ lib, buildDunePackage, fetchFromGitHub, ppxfind, ounit
, ppx_deriving, yojson
}:

buildDunePackage rec {
  pname = "ppx_deriving_yojson";
  version = "3.5.1";

  minimumOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = "ppx_deriving_yojson";
    rev = "v${version}";
    sha256 = "13nscby635vab9jf5pl1wgmdmqw192nf2r26m3gr01hp3bpn38zh";
  };

  buildInputs = [ ppxfind ounit ];

  propagatedBuildInputs = [ ppx_deriving yojson ];

  doCheck = true;

  meta = {
    description = "A Yojson codec generator for OCaml >= 4.04";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
