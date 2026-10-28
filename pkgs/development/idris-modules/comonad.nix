{
  build-idris-package,
  fetchFromGitHub,
  lib,
}:
build-idris-package {
  pname = "comonad";
  version = "2018-02-26";

  src = fetchFromGitHub {
    owner = "vmchale";
    repo = "comonad";
    rev = "23282592d4506708bdff79bfe1770c5f7a4ccb92";
    hash = "sha256-TA0wNQ2SprMBYrlXT+M9CA04DEuD/JiKTpkT+Uy3M0Y=";
  };

  meta = {
    description = "Comonads for Idris";
    homepage = "https://github.com/vmchale/comonad";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
