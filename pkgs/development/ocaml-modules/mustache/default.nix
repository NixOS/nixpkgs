{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ezjsonm,
  menhir,
  menhirLib,
<<<<<<< HEAD
  ounit2,
=======
  ounit,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildDunePackage rec {
  pname = "mustache";
<<<<<<< HEAD
  version = "3.3.0";
  src = fetchFromGitHub {
    owner = "rgrinberg";
    repo = "ocaml-mustache";
    tag = "v${version}";
    hash = "sha256-7rdp7nrjc25/Nuj/cf78qxS3Qy4ufaNcKjSnYh4Ri8U=";
  };

  nativeBuildInputs = [ menhir ];
  propagatedBuildInputs = [ menhirLib ];

  doCheck = false; # Disabled because of "Error: Program mustache-ocaml not found in the tree or in PATH"
  checkInputs = [
    ezjsonm
    ounit2
  ];
=======
  version = "3.1.0";
  duneVersion = "3";
  src = fetchFromGitHub {
    owner = "rgrinberg";
    repo = "ocaml-mustache";
    rev = "v${version}";
    sha256 = "19v8rk8d8lkfm2rmhdawfgadji6wa267ir5dprh4w9l1sfj8a1py";
  };

  nativeBuildInputs = [ menhir ];
  buildInputs = [ ezjsonm ];
  propagatedBuildInputs = [ menhirLib ];

  doCheck = true;
  checkInputs = [ ounit ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Mustache logic-less templates in OCaml";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
