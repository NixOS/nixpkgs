{
  build-idris-package,
  fetchFromGitHub,
  effects,
  lib,
}:
build-idris-package {
  pname = "lightyear";
  version = "2017-09-10";

  idrisDeps = [ effects ];

  src = fetchFromGitHub {
    owner = "ziman";
    repo = "lightyear";
    rev = "f737e25a09c1fe7c5fff063c53bd7458be232cc8";
    hash = "sha256-SeypsCQe8gepKpL6h85s2hPAzXR8OQWyN7WtC5cyphc=";
  };

  meta = {
    description = "Parser combinators for Idris";
    homepage = "https://github.com/ziman/lightyear";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      siddharthist
      brainrape
    ];
  };
}
