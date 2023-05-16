{ lib, stdenv, fetchFromGitHub, which, ocaml, findlib }:

if lib.versionOlder ocaml.version "4.10"
then throw "camlpdf is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "2.6";
=======
  version = "2.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "ocaml${ocaml.version}-camlpdf";

  src = fetchFromGitHub {
    owner = "johnwhitington";
    repo = "camlpdf";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-CJWVvZSbvSzG3PIr7w0vmbmY6tH59AgBAWRfDpQ9MCk=";
=======
    sha256 = "sha256:1qmsa0xgi960y7r20mvf8hxiiml7l1908s4dm7nq262f19w51gsl";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ which ocaml findlib ];

  strictDeps = true;

  preInstall = ''
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/stublibs
  '';

  meta = with lib; {
    description = "An OCaml library for reading, writing and modifying PDF files";
    homepage = "https://github.com/johnwhitington/camlpdf";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [vbgl];
  };
}
