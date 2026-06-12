{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ounit,
  qtest,
  qcheck,
  num,
  camlp-streams,
  doCheck ? true,
}:

buildDunePackage (finalAttrs: {
  pname = "batteries";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "ocaml-batteries-team";
    repo = "batteries-included";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RFozhk/kGgBg/2WnTYCNwi+kZwJ+l5o7z0YVons5yyw=";
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
    hasNoMaintainersButDependents = true;
  };
})
