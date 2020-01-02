{ lib
, buildDunePackage
, fetchFromGitHub
, ocaml
, core
, ppx_deriving
, ppxlib
, sexplib
}:

buildDunePackage rec {
  pname = "hack_parallel";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "rvantonder";
    repo = "hack-parallel";
    rev = "v${version}";
    sha256 = "051hbnj4lvvfdb3vs14apl7kwpdn9rbalnllfdc4xnhv3rzzxsyk";
  };

  buildInputs = [ core ppx_deriving ppxlib sexplib ];

  patches = [ ./dune-static-libs.patch ];

  meta = with lib; {
    description = "The core parallel and shared memory library used by Hack, Flow, and Pyre";
    homepage = "https://github.com/rvantonder/hack-parallel";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
