{
  buildDunePackage,
  atd-jsonlike,
  yamlx,
}:

buildDunePackage {
  pname = "atd-yamlx";
  inherit (atd-jsonlike) version src;

  propagatedBuildInputs = [
    atd-jsonlike
    yamlx
  ];

  meta = atd-jsonlike.meta // {
    description = "YAML-to-jsonlike bridge for use with ATD code generators";
  };
}
