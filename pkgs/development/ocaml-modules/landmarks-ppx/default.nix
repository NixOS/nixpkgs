{
  lib,
  buildDunePackage,
  ocaml,
  landmarks,
  ppxlib,
}:

buildDunePackage {
  pname = "landmarks-ppx";
  minimalOCamlVersion = "4.08";

  inherit (landmarks) src version;

  buildInputs = [ ppxlib ];
  propagatedBuildInputs = [ landmarks ];

  doCheck = lib.versionAtLeast ocaml.version "4.08" && lib.versionOlder ocaml.version "5.0";

  meta = landmarks.meta // {
    description = "Preprocessor instrumenting code using the landmarks library";
  };
}
