{
  lib,
  buildDunePackage,
  fetchFromGitHub,
}:

buildDunePackage rec {
  pname = "dtools";
  version = "0.4.6";

  minimalOCamlVersion = "4.05";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-dtools";
    rev = "v${version}";
    sha256 = "sha256-MIZM/IlPWPa/r/f8EXkhU8gZctOZeAIGZgxoGMF2IkE=";
  };

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/savonet/ocaml-dtools";
    description = "Library providing various helper functions to make daemons";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ dandellion ];
=======
  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-dtools";
    description = "Library providing various helper functions to make daemons";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dandellion ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
