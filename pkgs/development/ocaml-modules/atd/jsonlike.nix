{
  buildDunePackage,
  atd,
  re,
}:

buildDunePackage {
  pname = "atd-jsonlike";
  inherit (atd) src version;

  minimalOCamlVersion = "4.12";

  propagatedBuildInputs = [ re ];

  meta = (removeAttrs atd.meta [ "mainProgram" ]) // {
    description = "Generic JSON-like AST for use with ATD code generators";
  };
}
