{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage rec {
  pname = "jsony";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "treeform";
    repo = pname;
    rev = version;
    hash = "sha256-jtUCoqwCmE536Kpv/vZxGgqiHyReZf1WOiBdUzmMhM4=";
  };

  doCheck = true;

  meta = with lib;
    src.meta // {
      description = "A loose, direct to object json parser with hooks";
      license = [ licenses.mit ];
      maintainers = [ maintainers.erdnaxe ];
    };
}
