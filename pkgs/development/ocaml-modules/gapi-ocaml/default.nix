{ lib, fetchFromGitHub, buildDunePackage, ocaml
, cryptokit, ocamlnet, ocurl, yojson
, ounit2
}:

buildDunePackage rec {
  pname = "gapi-ocaml";
  version = "0.4.3";

  minimalOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-V0GB9Bd06IdcI5PDFHGVZ0Y/qi7tTs/4ITqPXUOxCLs=";
  };

  propagatedBuildInputs = [ cryptokit ocamlnet ocurl yojson ];

  doCheck = lib.versionAtLeast ocaml.version "4.04";
  checkInputs = [ ounit2 ];

  meta = {
    description = "OCaml client for google services";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bennofs ];
  };
}
