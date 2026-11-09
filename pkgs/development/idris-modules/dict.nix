{
  build-idris-package,
  fetchFromGitHub,
  contrib,
  lib,
}:
build-idris-package {
  pname = "dict";
  version = "2016-12-26";

  idrisDeps = [ contrib ];

  src = fetchFromGitHub {
    owner = "be5invis";
    repo = "idris-dict";
    rev = "dddc7c9f45e079b151ee03c9752b968ceeab9dab";
    hash = "sha256-MaL+Fk5Vh+10hKV+ghJUJiEiQ+EgcJE8QehdtQHBMaM=";
  };

  postUnpack = ''
    sed -i 's/\"//g' source/dict.ipkg
  '';

  meta = {
    description = "Dict k v in Idris";
    homepage = "https://github.com/be5invis/idris-dict";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
