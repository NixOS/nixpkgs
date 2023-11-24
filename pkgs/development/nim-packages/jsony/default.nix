{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage rec {
  pname = "jsony";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "treeform";
    repo = pname;
    rev = version;
    sha256 = "1720iqsxjhqmhw1zhhs7d2ncdz25r8fqadls1p1iry1wfikjlnba";
  };


  meta = with lib;
    src.meta // {
      description = "A loose, direct to object json parser with hooks";
      license = [ licenses.mit ];
      maintainers = [ maintainers.erdnaxe ];
    };
}
