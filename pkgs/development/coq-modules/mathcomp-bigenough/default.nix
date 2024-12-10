{
  coq,
  mkCoqDerivation,
  mathcomp,
  lib,
  version ? null,
}:

mkCoqDerivation {

  namePrefix = [
    "coq"
    "mathcomp"
  ];
  pname = "bigenough";
  owner = "math-comp";

  release = {
    "1.0.0".sha256 = "10g0gp3hk7wri7lijkrqna263346wwf6a3hbd4qr9gn8hmsx70wg";
    "1.0.1".sha256 = "sha256:02f4dv4rz72liciwxb2k7acwx6lgqz4381mqyq5854p3nbyn06aw";
  };
  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.version [
      {
        case = range "8.10" "8.19";
        out = "1.0.1";
      }
      {
        case = range "8.5" "8.14";
        out = "1.0.0";
      }
    ] null;

  propagatedBuildInputs = [ mathcomp.ssreflect ];

  meta = {
    description = "A small library to do epsilon - N reasonning";
    license = lib.licenses.cecill-b;
  };
}
