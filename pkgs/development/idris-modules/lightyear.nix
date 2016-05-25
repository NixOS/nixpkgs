{ build-idris-package
, fetchFromGitHub
, prelude
, base
, effects
, lib
, idris
}: build-idris-package {
  name = "lightyear";

  src = fetchFromGitHub {
    owner = "ziman";
    repo = "lightyear";
    rev = "3d4f025a77159af3a2d12c803d783405c9b0a04b";
    sha256 = "1cbxxhwqsn5nv1y5wzgyl61qcjsah6lz532szpg1jicwwzh748vs";
  };

  propagatedBuildInputs = [ prelude base effects ];

  meta = {
    description = "Parser combinators for Idris";
    homepage = https://github.com/ziman/lightyear;
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ gpyh ];
    inherit (idris.meta) platforms;
  };
}
