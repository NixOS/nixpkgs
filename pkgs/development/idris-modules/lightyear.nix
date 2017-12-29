{ build-idris-package
, fetchFromGitHub
, prelude
, base
, effects
, lib
, idris
}:

let
  date = "2017-09-10";
in
build-idris-package {
  name = "lightyear-${date}";

  src = fetchFromGitHub {
    owner = "ziman";
    repo = "lightyear";
    rev = "f737e25a09c1fe7c5fff063c53bd7458be232cc8";
    sha256 = "05x66abhpbdm6yr0afbwfk6w04ysdk78gylj5alhgwhy4jqakv29";
  };

  propagatedBuildInputs = [ prelude base effects ];

  meta = {
    description = "Parser combinators for Idris";
    homepage = https://github.com/ziman/lightyear;
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.siddharthist ];
    inherit (idris.meta) platforms;
  };
}
