{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ocaml,
  ounit,
  qtest,
  qcheck,
  num,
  camlp-streams,
  doCheck ? lib.versionAtLeast ocaml.version "4.08",
}:

buildDunePackage rec {
  pname = "batteries";
  version = "3.9.0";

  minimalOCamlVersion = "4.05";

  src = fetchFromGitHub {
    owner = "ocaml-batteries-team";
    repo = "batteries-included";
    rev = "v${version}";
    hash = "sha256-+PGfExdvp3WyX1s8dLTBYp1SoUOBkzrxyqMUuaW6Bto=";
  };

  nativeCheckInputs = [ qtest ];
  checkInputs = [
    ounit
    qcheck
  ];
  propagatedBuildInputs = [
    camlp-streams
    num
  ];

  inherit doCheck;
  checkTarget = "test";

  meta = {
    homepage = "https://ocaml-batteries-team.github.io/batteries-included/hdoc2/";
    description = "OCaml Batteries Included";
    longDescription = ''
      A community-driven effort to standardize on an consistent, documented,
      and comprehensive development platform for the OCaml programming
      language.
    '';
    license = lib.licenses.lgpl21Plus;
    maintainers = [
      lib.maintainers.maggesi
    ];
  };
}
