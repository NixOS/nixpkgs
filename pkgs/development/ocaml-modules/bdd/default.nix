{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  stdlib-shims,
}:

buildDunePackage {
  pname = "bdd";
  version = "unstable-2022-07-14";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "backtracking";
    repo = "ocaml-bdd";
    rev = "6d1b1d3c24e5784b87e599a00230ce652acb2dcc";
    hash = "sha256-3mJZlAFQsI7AgrNQOe6N94CDfX5gXYqQBooV0jcoYEA=";
  };

  # Fix build with OCaml 4.02
  postPatch = ''
    substituteInPlace lib/bdd.ml \
      --replace "Buffer.truncate Format.stdbuf 0;" "Buffer.clear Format.stdbuf;"
  '';

  propagatedBuildInputs = [
    stdlib-shims
  ];

  meta = with lib; {
    description = "Quick implementation of a Binary Decision Diagrams (BDD) library for OCaml";
    homepage = "https://github.com/backtracking/ocaml-bdd";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ wegank ];
  };
}
