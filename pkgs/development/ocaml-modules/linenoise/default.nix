{ lib, fetchFromGitHub, buildDunePackage, result }:

buildDunePackage rec {
  pname = "linenoise";
  version = "1.5";

  minimalOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "fxfactorial";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    sha256 = "sha256-ywcL5w65XXqInREalf0aDxvoEYA6tZW9eU5NGI/QETI=";
  };

  propagatedBuildInputs = [ result ];

  meta = {
    description = "OCaml bindings to linenoise";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
