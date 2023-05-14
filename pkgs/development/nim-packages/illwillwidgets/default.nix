{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage rec {
  pname = "illwillwidgets";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "enthus1ast";
    repo = "illwillWidgets";
    rev = "04f507cfd651df430b1421403b3a70cb061c4624";
    hash = "sha256-YVNdgs8jquJ58qbcyNMMJt+hJYcvahYpkSrDBbO4ILU=";
  };

  meta = with lib;
    src.meta // {
      description = "Mouse enabled widgets for illwill";

      license = [ licenses.mit ];
      maintainers = with maintainers; [ marcusramberg ];
    };
}
