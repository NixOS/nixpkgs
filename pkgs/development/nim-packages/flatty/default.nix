{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage rec {
  pname = "flatty";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "treeform";
    repo = pname;
    rev = version;
    hash = "sha256-1tPLtnlGtE4SF5/ti/2svvYHpEy/0Za5N4YAOHFOyjA=";
  };

  doCheck = true;

  meta = with lib;
    src.meta // {
      description = "Tools and serializer for plain flat binary files";
      license = [ licenses.mit ];
      maintainers = [ maintainers.ehmry ];
    };
}
