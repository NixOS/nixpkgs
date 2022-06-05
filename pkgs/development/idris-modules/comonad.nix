{ build-idris-package
, fetchFromGitHub
, lib
}:
build-idris-package  {
  pname = "comonad";
  version = "2018-02-26";

  src = fetchFromGitHub {
    owner = "vmchale";
    repo = "comonad";
    rev = "23282592d4506708bdff79bfe1770c5f7a4ccb92";
    sha256 = "0iiknx6gj4wr9s59iz439c63h3887pilymxrc80v79lj1lsk03ac";
  };

  meta = {
    description = "Comonads for Idris";
    homepage = "https://github.com/vmchale/comonad";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
