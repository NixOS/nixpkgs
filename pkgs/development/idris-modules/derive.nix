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
    sha256 = "06za15m1kv9mijzll5712crry4iwx3b0fjv76gy9vv1p10gy2g4m";
  };

  meta = {
    description = "Type class deriving with elaboration reflection";
    homepage = "https://github.com/davlum/derive-all-the-instances";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
