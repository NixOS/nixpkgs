{
  lib,
  buildDunePackage,
  atd,
  cmdliner,
}:

buildDunePackage {
  pname = "atdml";
  inherit (atd) version src;

  buildInputs = [ cmdliner ];

  propagatedBuildInputs = [ atd ];

  meta = atd.meta // {
    description = "Simplified OCaml JSON serializers using the Yojson AST";
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "atdml";
  };
}
