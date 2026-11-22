{
  build-idris-package,
  fetchFromGitHub,
  lib,
}:
build-idris-package {
  pname = "hezarfen";
  version = "2018-02-03";

  src = fetchFromGitHub {
    owner = "joom";
    repo = "hezarfen";
    rev = "079884d85619cd187ae67230480a1f37327f8d78";
    hash = "sha256-t4d1RDwc7o/STKZtmGT8J0fW0pdydUBHJabfrR4ogXw=";
  };

  meta = {
    description = "Theorem prover for intuitionistic propositional logic in Idris, with metaprogramming features";
    homepage = "https://github.com/joom/hezarfen";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
