{ stdenv, lib, fetchFromGitHub, buildDunePackage, ocaml, qtest, qcheck, num, camlp-streams
, doCheck ? lib.versionAtLeast ocaml.version "4.08"
}:

buildDunePackage rec {
  pname = "batteries";
  version = "3.7.2";

  minimalOCamlVersion = "4.05";

  src = fetchFromGitHub {
    owner = "ocaml-batteries-team";
    repo = "batteries-included";
    rev = "v${version}";
    hash = "sha256-POhdb6d4VZyCm9QYgj0m3ejduaBmm+cnd1tshWjgp04=";
  };

  nativeCheckInputs = [ qtest ];
  checkInputs = [ qcheck ];
  propagatedBuildInputs = [ camlp-streams num ];

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
