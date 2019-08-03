{ build-idris-package
, fetchFromGitHub
, lib
}:
build-idris-package  {
  name = "quantities";
  version = "2018-04-17";

  src = fetchFromGitHub {
    owner = "timjb";
    repo = "quantities";
    rev = "76bb872bd89122043083351993140ae26eb91ead";
    sha256 = "0fv12kdi9089b4kkr6inhqvs2s8x62nv5vqj76wzk8hy0lrzylzj";
  };

  meta = {
    description = "Type-safe physical computations and unit conversions in Idris";
    homepage = https://github.com/timjb/quantities;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ imuli ];
  };
}
