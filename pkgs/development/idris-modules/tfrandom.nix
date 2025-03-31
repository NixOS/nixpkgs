{
  lib,
  build-idris-package,
  fetchFromGitHub,
}:

build-idris-package {
  pname = "tf-random";
  version = "2020-01-15";

  src = fetchFromGitHub {
    owner = "david-christiansen";
    repo = "idris-tf-random";
    rev = "202aac3b96757e8247f6e26945329d90dd668aed";
    sha256 = "1z8pyrsm1kdsspcs3h96k38h44ss0mv39lcz7xvwg8ickys3kqxl";
  };

  meta = {
    description = "Port of Haskell tf-random";
    homepage = "https://github.com/david-christiansen/idris-tf-random";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.mikesperber ];
  };
}
