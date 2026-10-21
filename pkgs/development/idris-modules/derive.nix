{
  build-idris-package,
  fetchFromGitHub,
  contrib,
  pruviloj,
  lib,
}:
build-idris-package {
  pname = "derive";
  version = "2018-07-02";

  idrisDeps = [
    contrib
    pruviloj
  ];

  src = fetchFromGitHub {
    owner = "david-christiansen";
    repo = "derive-all-the-instances";
    rev = "0a9a5082d4ab6f879a2c141d1a7b645fa73fd950";
    hash = "sha256-lTzhHwg37J38M2dLB9boPBKfMxPhFEq/jDXtGWoJ6hs=";
  };

  meta = {
    description = "Type class deriving with elaboration reflection";
    homepage = "https://github.com/davlum/derive-all-the-instances";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
