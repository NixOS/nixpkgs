{
  lib,
  fetchFromGitHub,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "octavius";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "ocaml-doc";
    repo = "octavius";
    rev = "v${version}";
    sha256 = "sha256-/S6WpIo1c5J9uM3xgtAM/elhnsl0XimnIFsKy3ootbA=";
  };

  minimalOCamlVersion = "4.03";

  doCheck = true;

<<<<<<< HEAD
  meta = {
    description = "Ocamldoc comment syntax parser";
    homepage = "https://github.com/ocaml-doc/octavius";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ vbgl ];
=======
  meta = with lib; {
    description = "Ocamldoc comment syntax parser";
    homepage = "https://github.com/ocaml-doc/octavius";
    license = licenses.isc;
    maintainers = with maintainers; [ vbgl ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
