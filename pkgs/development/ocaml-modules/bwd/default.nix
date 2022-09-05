{ lib, fetchFromGitHub, buildDunePackage, qcheck-core }:

buildDunePackage rec {
  pname = "bwd";
  version = "2.0.0";

  minimalOCamlVersion = "4.12";

  src = fetchFromGitHub {
    owner = "RedPRL";
    repo = "ocaml-bwd";
    rev = version;
    sha256 = "sha256:0zgi8an53z6wr6nzz0zlmhx19zhqy1w2vfy1sq3sikjwh74jjq60";
  };

  doCheck = true;
  checkInputs = [ qcheck-core ];

  meta = {
    description = "Backward Lists";
    inherit (src.meta) homepage;
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
