{
  build-idris-package,
  fetchFromGitHub,
  contrib,
  patricia,
  lib,
}:
build-idris-package {
  pname = "semidirect";
  version = "2018-07-02";

  idrisDeps = [
    contrib
    patricia
  ];

  src = fetchFromGitHub {
    owner = "clayrat";
    repo = "idris-semidirect";
    rev = "e19c58f7a25c53bba2ab058821e038bae3c093d2";
    hash = "sha256-NLMZ72BigVXJAaP4jzWRGI5nEXGY8IsOHXtNMn7KAgU=";
  };

  meta = {
    description = "Semidirect products in Idris";
    homepage = "https://github.com/clayrat/idris-semidirect";
    maintainers = [ lib.maintainers.brainrape ];
  };
}
