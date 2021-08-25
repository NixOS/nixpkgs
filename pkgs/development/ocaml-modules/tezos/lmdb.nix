{ lib
, fetchFromGitLab
, pkg-config
, buildDunePackage
, lmdb
, rresult
, cstruct
, alcotest
}:

buildDunePackage rec {
  pname = "tezos-lmdb";
  version = "7.4";
  src = fetchFromGitLab {
    owner = "tezos";
    repo = "tezos";
    rev = "v${version}";
    sha256 = "18q02j74aa8mxv233kvyb62xbhjngzpgppp6kgr4m53d7a78wgsm";
  };

  useDune2 = true;

  preBuild = ''
    rm dune
    rm -rf src
    rm -rf docs
    ls vendors | grep -v ocaml-lmdb |xargs rm -rf
  '';

  buildInputs = [
    pkg-config
  ];

  propagatedBuildInputs = [
    rresult
    lmdb
  ];

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
