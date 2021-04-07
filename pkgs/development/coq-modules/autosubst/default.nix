{ lib, mkCoqDerivation, coq, mathcomp, version ? null }:

with lib; mkCoqDerivation {
  pname   = "autosubst";
  owner   = "uds-psl";
  inherit version;
  defaultVersion = with versions;
    if range "8.5" "8.7" coq.coq-version then "5b40a32e" else null;

  release."5b40a32e".rev    = "1c3bb3bbf5477e3b33533a0fc090399f45fe3034";
  release."5b40a32e".sha256 = "1wqfzc9az85fvx71xxfii502jgc3mp0r3xwfb8vnb03vkk625ln0";

  propagatedBuildInputs = [ mathcomp.ssreflect ];

  patches = [./0001-changes-to-work-with-Coq-8.6.patch];

  meta = {
    homepage = "https://www.ps.uni-saarland.de/autosubst/";
    description = "Automation for de Bruijn syntax and substitution in Coq";
    maintainers = with maintainers; [ jwiegley ];
  };
}
