{
  lib,
  buildDunePackage,
  ocaml,
  landmarks,
  ppxlib,
}:

buildDunePackage {
  pname = "landmarks-ppx";

  inherit (landmarks) src version;

  buildInputs = [ ppxlib ];
  propagatedBuildInputs = [ landmarks ];

  doCheck = lib.versionAtLeast ocaml.version "5.1";

  meta = landmarks.meta // {
    description = "Preprocessor instrumenting code using the landmarks library";
    longDescription = ''
      Automatically or semi-automatically instrument your code using
      landmarks library.
    '';
    broken = lib.versionAtLeast ppxlib.version "0.36";
  };
}
