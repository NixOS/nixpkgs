{ buildDunePackage, github
, yojson, atdgen
}:

buildDunePackage {
  pname = "github-data";
  inherit (github) version src;

  duneVersion = "3";

  nativeBuildInputs = [
    atdgen
  ];

  propagatedBuildInputs = [
    yojson
    atdgen
  ];

  meta = github.meta // {
    description = "GitHub APIv3 data library";
  };
}
