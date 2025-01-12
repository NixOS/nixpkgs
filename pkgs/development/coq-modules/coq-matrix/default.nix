{
  lib,
  mkCoqDerivation,
  coq,
  version ? null
}:
mkCoqDerivation {
  pname = "matrix";
  owner = "zhengpushi";
  repo = "CoqMatrix";
  inherit version;  
  defaultVersion =  switch [ coq.version ] [
      { cases = [ (range "8.7" "8.18")  "1.11.0" ];             out = "1.0.6"; }
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
