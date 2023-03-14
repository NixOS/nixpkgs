{ lib, buildNimPackage, fetchFromGitHub, vmath }:

buildNimPackage rec {
  pname = "bumpy";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "treeform";
    repo = pname;
    rev = version;
    hash = "sha256-mDmDlhOGoYYjKgF5j808oT2NqRlfcOdLSDE3WtdJFQ0=";
  };

  propagatedBuildInputs = [ vmath ];

  doCheck = true;

  meta = with lib;
    src.meta // {
      description = "2d collision library";
      license = [ licenses.mit ];
      maintainers = [ maintainers.ehmry ];
    };
}
