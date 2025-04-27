{
  lib,
  mkCoqDerivation,
  coq,
  version ? null,
}:
mkCoqDerivation {
  owner = "zhengpushi";
  pname = "CoqMatrix";
  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.version [
      {
        case = range "8.11" "8.18";
        out = "1.0.6";
      }
    ] null;
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
