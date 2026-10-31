{
  build-idris-package,
  fetchFromGitHub,
  lib,
}:
build-idris-package {
  pname = "quantities";
  version = "2018-04-17";

  src = fetchFromGitHub {
    owner = "timjb";
    repo = "quantities";
    rev = "76bb872bd89122043083351993140ae26eb91ead";
    hash = "sha256-8lP/MwUeovm5ORLvsq0wHWmhN4Y2mjwnWQmBFNsUYTs=";
  };

  meta = {
    description = "Type-safe physical computations and unit conversions in Idris";
    homepage = "https://github.com/timjb/quantities";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ imuli ];
  };
}
