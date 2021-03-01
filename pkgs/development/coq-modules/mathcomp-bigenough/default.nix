{ coq, mkCoqDerivation, mathcomp, lib, version ? null }:

with lib; mkCoqDerivation {

  namePrefix = [ "coq" "mathcomp" ];
  pname = "bigenough";
  owner = "math-comp";

  release = { "1.0.0".sha256 = "10g0gp3hk7wri7lijkrqna263346wwf6a3hbd4qr9gn8hmsx70wg"; };
  inherit version;
  defaultVersion = "1.0.0";

  propagatedBuildInputs = [ mathcomp.ssreflect ];

  meta = {
    description = "A small library to do epsilon - N reasonning";
    license = licenses.cecill-b;
  };
}
