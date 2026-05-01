{
  lib,
  buildDunePackage,
  fetchpatch,
  ocaml,
  landmarks,
  ppxlib,
}:

buildDunePackage {
  pname = "landmarks-ppx";
  minimalOCamlVersion = "4.08";

  inherit (landmarks) src version;

  patches = lib.optional (lib.versionAtLeast ppxlib.version "0.36") (fetchpatch {
    url = "https://github.com/LexiFi/landmarks/commit/367c229e3275a83f81343ba116374bb68abc9d83.patch";
    hash = "sha256-Qxue+++sNV6EHJGX1mbIeY2E2D5NuFpmIIBkTyvGvo8=";
  });

  buildInputs = [ ppxlib ];
  propagatedBuildInputs = [ landmarks ];

  doCheck = lib.versionAtLeast ocaml.version "4.08" && lib.versionOlder ocaml.version "5.0";

  meta = landmarks.meta // {
    description = "Preprocessor instrumenting code using the landmarks library";
    longDescription = ''
      Automatically or semi-automatically instrument your code using
      landmarks library.
    '';
  };
}
