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
    sha256 = "18riq40vapg884y92w10w51j4896ah984zm5hisfv1sm9qbgx8ii";
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
