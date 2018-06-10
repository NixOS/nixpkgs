{ build-idris-package
, fetchFromGitHub
, prelude
, lib
, idris
}:
build-idris-package  {
  name = "canvas";
  version = "2017-11-09";

  idrisDeps = [ prelude ];

  src = fetchFromGitHub {
    owner = "JinWuZhao";
    repo = "idriscanvas";
    rev = "2957c78c0721ec3afaee9d64e051a8f8d9b6f426";
    sha256 = "0jirkqciv3j1phpm2v6fmch40b5a01rmqdng16y8mihq1wb70ayy";
  };

  meta = {
    description = "Idris FFI binding for html5 canvas 2d api";
    homepage = https://github.com/JinWuZhao/idriscanvas;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
