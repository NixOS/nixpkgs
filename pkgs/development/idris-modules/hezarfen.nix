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
    sha256 = "0z4150gavpx64m3l0xbjjz9dcir7zij9hvd69k98zvhw7i27b1xp";
  };

  meta = {
    description = "Theorem prover for intuitionistic propositional logic in Idris, with metaprogramming features";
    homepage = "https://github.com/joom/hezarfen";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
