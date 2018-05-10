{ build-idris-package
, fetchFromGitHub
, prelude
, effects
, lib
, idris
}:
build-idris-package  {
  name = "farrp";
  version = "2018-02-13";

  idrisDeps = [ prelude effects ];

  src = fetchFromGitHub {
    owner = "lambda-11235";
    repo = "FarRP";
    rev = "d592957232968743f8862e49d5a8d52e13340444";
    sha256 = "1zrf750d7x1cz7kkgcx4ipa87hkg10adwii4qqvz9vpjap7vh7h0";
  };

  meta = {
    description = "Arrowized FRP library for Idris with static safety guarantees";
    homepage = https://github.com/lambda-11235/FarRP;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
