{ stdenv, lib, fetchFromGitHub, expat, ocaml, findlib, ounit }:

<<<<<<< HEAD
lib.throwIfNot (lib.versionAtLeast ocaml.version "4.02")
  "ocaml_expat is not available for OCaml ${ocaml.version}"

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-expat";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "whitequark";
    repo = "ocaml-expat";
    rev = "v${version}";
    sha256 = "07wm9663z744ya6z2lhiz5hbmc76kkipg04j9vw9dqpd1y1f2x3q";
  };

  prePatch = ''
    substituteInPlace Makefile --replace "gcc" "\$(CC)"
  '';

  nativeBuildInputs = [ ocaml findlib ];
<<<<<<< HEAD
  buildInputs = [ expat ];

  strictDeps = true;

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkTarget = "testall";
  checkInputs = [ ounit ];
=======
  buildInputs = [ expat ounit ];

  strictDeps = true;

  doCheck = lib.versionOlder ocaml.version "4.06";
  checkTarget = "testall";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  createFindlibDestdir = true;

  meta = {
    description = "OCaml wrapper for the Expat XML parsing library";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
  };
}
