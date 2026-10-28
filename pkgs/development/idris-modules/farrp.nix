{
  build-idris-package,
  fetchFromGitHub,
  effects,
  lib,
}:
build-idris-package {
  pname = "farrp";
  version = "2018-02-13";

  idrisDeps = [ effects ];

  src = fetchFromGitHub {
    owner = "lambda-11235";
    repo = "FarRP";
    rev = "d592957232968743f8862e49d5a8d52e13340444";
    hash = "sha256-AB64z1Xy7vQ3xiRG3hQIb8KD1I2kszfn+Sz000A5Lv8=";
  };

  meta = {
    description = "Arrowized FRP library for Idris with static safety guarantees";
    homepage = "https://github.com/lambda-11235/FarRP";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
