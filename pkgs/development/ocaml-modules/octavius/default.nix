{ lib, fetchFromGitHub, buildDunePackage, ocaml }:

buildDunePackage rec {
  pname = "octavius";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "ocaml-doc";
    repo = "octavius";
    rev = "v${version}";
    sha256 = "sha256-/S6WpIo1c5J9uM3xgtAM/elhnsl0XimnIFsKy3ootbA=";
  };

  minimumOCamlVersion = "4.03";
  useDune2 = lib.versionAtLeast ocaml.version "4.08";

  doCheck = true;

  meta = with lib; {
    description = "Ocamldoc comment syntax parser";
    homepage = "https://github.com/ocaml-doc/octavius";
    license = licenses.isc;
    maintainers = with maintainers; [ vbgl ];
  };
}
