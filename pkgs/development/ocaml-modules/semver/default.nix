{
  lib,
  fetchurl,
  buildDunePackage,
  ocaml,
  alcotest,
}:

buildDunePackage rec {
  pname = "semver";
  version = "0.2.1";
  src = fetchurl {
    url = "https://github.com/rgrinberg/ocaml-semver/releases/download/${version}/semver-${version}.tbz";
    hash = "sha256-CjzDUtoe5Hvt6zImb+EqVIulRUUUQd9MmuJ4BH/2mLg=";
  };

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ alcotest ];

  meta = {
    homepage = "https://github.com/rgrinberg/ocaml-semver";
    description = "Semantic versioning module";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
