{
  lib,
  buildDunePackage,
  ocaml,
  alcotest,
  atd,
  atd-jsonlike,
  atd-yamlx,
  atdgen-codec-runtime,
  atdgen-runtime,
  atdml,
  biniou,
  re,
  yamlx,
}:

buildDunePackage {
  pname = "atdgen";
  inherit (atdgen-codec-runtime) version src;

  buildInputs = [
    atd
    re
  ];

  propagatedBuildInputs = [ atdgen-runtime ];

  doCheck = lib.versionAtLeast ocaml.version "4.14";
  nativeCheckInputs = [
    atd
    atdml
    biniou
  ];
  checkInputs = [
    alcotest
    atdgen-codec-runtime
    yamlx
    atd-jsonlike
    atd-yamlx
  ];

  meta = (removeAttrs atd.meta [ "mainProgram" ]) // {
    description = "Generates efficient JSON serializers, deserializers and validators";
  };
}
