{
  build-idris-package,
  fetchFromGitHub,
  contrib,
  lib,
}:
build-idris-package {
  pname = "iaia";
  version = "2017-11-10";

  idrisDeps = [ contrib ];

  src = fetchFromGitHub {
    owner = "sellout";
    repo = "Iaia";
    rev = "dce68d2b63a26dad7c94459773eae2d42686fa05";
    sha256 = "0209fhv8x3sw6ijrwc8a85pch97z821ygaz78va3l274xam4l659";
  };

  meta = {
    description = "Recursion scheme library for Idris";
    homepage = "https://github.com/sellout/Iaia";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
