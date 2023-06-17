{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage rec {
  pname = "jsony";
  version = "d0e69bddf83874e15b5c2f52f8b1386ac080b443";

  src = fetchFromGitHub {
    owner = "treeform";
    repo = pname;
    rev = version;
    sha256 = "1p250wb97nzz2g0vvq6mn521fx7sn1jpk1ralbzqh5q8clh4g7wr";
  };

  doCheck = true;

  meta = with lib;
    src.meta // {
      description = "A loose, direct to object json parser with hooks";
      license = [ licenses.mit ];
      maintainers = [ maintainers.erdnaxe ];
    };
}
