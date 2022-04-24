{ lib
, fetchFromGitLab
, pkg-config
, buildDunePackage
, lmdb
, rresult
, cstruct
, alcotest
}:

let
  version = "7.4";
  src = fetchFromGitLab {
    owner = "tezos";
    repo = "tezos";
    rev = "v${version}";
    sha256 = "0sghc60xzr02pmmkr626pnhzrnczf7mki7qyxzzfn7rbbdbrf4wp";
  };
in

buildDunePackage {
  pname = "tezos-lmdb";
  version = version;
  src = "${src}/vendors/ocaml-lmdb";

  useDune2 = true;

  nativeBuildInputs = [
    pkg-config
  ];

  propagatedBuildInputs = [
    rresult
    lmdb
  ];

  strictDeps = true;

  checkInputs = [
    cstruct
    alcotest
  ];

  doCheck = false;

  meta = {
    description = "Legacy Tezos OCaml binding to LMDB (Consider ocaml-lmdb instead)";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
