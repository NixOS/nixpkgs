{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  stdlib-shims,
}:

buildDunePackage rec {
  pname = "bdd";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "backtracking";
    repo = "ocaml-bdd";
    tag = version;
    hash = "sha256-bhgKpo7gGkjbI75pzckfQulZnTstj6G5QcErLgIGneU=";
  };

  # Fix build with OCaml 4.02
  postPatch = ''
    substituteInPlace lib/bdd.ml \
      --replace-fail "Buffer.truncate Format.stdbuf 0;" "Buffer.clear Format.stdbuf;"
  '';

  propagatedBuildInputs = [
    stdlib-shims
  ];

  meta = {
    description = "Quick implementation of a Binary Decision Diagrams (BDD) library for OCaml";
    homepage = "https://github.com/backtracking/ocaml-bdd";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
