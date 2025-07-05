{
  lib,
  buildDunePackage,
  fetchFromGitLab,
  afl-persistent,
  pprint,
  version ? "20250314",
}:

buildDunePackage {
  pname = "monolith";
  inherit version;

  minimalOCamlVersion = "4.12";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "fpottier";
    repo = "monolith";
    tag = version;
    hash = "sha256-hIB3QSOLARumRgpUroTFUzSreHw7kMikGde+mB28sGM=";
  };

  propagatedBuildInputs = [
    afl-persistent
    pprint
  ];

  meta = {
    description = "Facilities for testing an OCaml library";
    homepage = "https://cambium.inria.fr/~fpottier/monolith/doc/monolith/Monolith/index.html";
    changelog = "https://gitlab.inria.fr/fpottier/monolith/-/raw/${version}/CHANGES.md";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
