{ lib, buildDunePackage, fetchFromGitHub, ezjsonm, menhir, ounit }:

buildDunePackage rec {
  pname = "mustache";
  version = "3.1.0";
  src = fetchFromGitHub {
    owner = "rgrinberg";
    repo = "ocaml-mustache";
    rev = "v${version}";
    sha256 = "19v8rk8d8lkfm2rmhdawfgadji6wa267ir5dprh4w9l1sfj8a1py";
  };

  buildInputs = [ ezjsonm ];
  propagatedBuildInputs = [ menhir ];

  doCheck = true;
  checkInputs = [ ounit ];

  meta = {
    description = "Mustache logic-less templates in OCaml";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
