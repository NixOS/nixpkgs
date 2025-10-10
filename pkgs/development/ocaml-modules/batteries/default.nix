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

buildDunePackage (finalAttrs: {
  pname = "batteries";
  version = "3.10.0";

  minimalOCamlVersion = "4.05";

  src = fetchFromGitHub {
    owner = "ocaml-batteries-team";
    repo = "batteries-included";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cD0O4kEDE58yCYnUuS83O1CJNHJuCGVhvKJSKQeQGkc=";
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
})
