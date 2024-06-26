{ build-idris-package
, fetchFromGitHub
, lib
}:
build-idris-package  {
  pname = "free";
  version = "2017-07-03";

  ipkgName = "idris-free";

  src = fetchFromGitHub {
    owner = "idris-hackers";
    repo = "idris-free";
    rev = "919950fb6a9d97c139c2d102402fec094a99c397";
    sha256 = "1n4daf1acjkd73an4m31yp9g616crjb7h5z02f1gj29wm3dbx5s7";
  };

  meta = {
    description = "Free Monads and useful constructions to work with them";
    homepage = "https://github.com/idris-hackers/idris-free";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
