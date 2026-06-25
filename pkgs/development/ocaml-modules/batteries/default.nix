{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ocaml,
  fetchpatch,
  ounit,
  qtest,
  qcheck,
  num,
  camlp-streams,
  doCheck ? true,
}:

buildDunePackage (finalAttrs: {
  pname = "batteries";
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "ocaml-batteries-team";
    repo = "batteries-included";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cD0O4kEDE58yCYnUuS83O1CJNHJuCGVhvKJSKQeQGkc=";
  };

  patches = lib.optional (lib.versionAtLeast ocaml.version "5.5") (fetchpatch {
    url = "https://github.com/ocaml-batteries-team/batteries-included/commit/f6e091266599aea93c8a94115cf08f50e88c5dd0.patch";
    hash = "sha256-6CUcq24x4fnumduK4BJ5cVQ5DHPbVLyLUxl57q2JVtw=";
  });

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
  };
})
