{
  lib,
  mkCoqDerivation,
  coq
}:
mkCoqDerivation {
  pname = "matrix";
  owner = "zhengpushi";
  repo = "CoqMatrix";
  defaultVersion = "1.0.6";
  release = {
    "1.0.6".sha256 = "sha256-XsM3fSstvB6GE5OqT7CFro+RWiYEgJsoQ5gXd74VaK0=";
  };
  meta = {
    homepage = "https://github.com/zhengpushi/CoqMatrix";
    description = "Matrix math";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ damhiya ];
  };
}
