{ build-idris-package
, fetchFromGitHub
, prelude
, base
, effects
, lib
, idris
}:

let
  date = "2016-08-01";
in
build-idris-package {
  name = "lightyear-${date}";

  src = fetchFromGitHub {
    owner = "ziman";
    repo = "lightyear";
    rev = "9420f9e892e23a7016dea1a61d8ce43a6d4ecf15";
    sha256 = "0xbjwq7sk4x78mi2zcqxbx7wziijlr1ayxihb1vml33lqmsgl1dn";
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
