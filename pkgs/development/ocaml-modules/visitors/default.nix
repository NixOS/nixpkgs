{
  lib,
  buildDunePackage,
  fetchFromGitLab,
  ppxlib,
  ppx_deriving,
  result,
  version ? if lib.versionAtLeast ppxlib.version "0.36" then "20260520" else "20250212",
}:

buildDunePackage {
  pname = "visitors";
  inherit version;

  minimalOCamlVersion = "4.08";

  src = fetchFromGitLab {
    owner = "fpottier";
    repo = "visitors";
    tag = version;
    domain = "gitlab.inria.fr";
    hash =
      {
        "20250212" = "sha256-AFD4+vriwVGt6lzDyIDuIMadakcgB4j235yty5qqFgQ=";
        "20260520" = "sha256-QR/kxwojyFOFLeu1JKjBfgmq2xaGZHq8hB1YwVpRVYI=";
      }
      ."${version}";
  };

  propagatedBuildInputs = [
    ppxlib
    ppx_deriving
    result
  ];

  meta = {
    homepage = "https://gitlab.inria.fr/fpottier/visitors";
    changelog = "https://gitlab.inria.fr/fpottier/visitors/-/raw/${version}/CHANGES.md";
    license = lib.licenses.lgpl21;
    description = "OCaml syntax extension (technically, a ppx_deriving plugin) which generates object-oriented visitors for traversing and transforming data structures";
    maintainers = [ ];
  };
}
