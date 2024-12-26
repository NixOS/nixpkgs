{
  lib,
  mkCoqDerivation,
  coq,
  version ? null,
  iris,
}:

mkCoqDerivation rec {
  pname = "iris-named-props";
  owner = "tchajed";
  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.version [
      {
        case = range "8.16" "8.19";
        out = "2023-08-14";
      }
    ] null;
  release."2023-08-14".sha256 = "sha256-gu9qOdHO0qJ2B9Y9Vf66q08iNJcfuECJO66fizFB08g=";
  release."2023-08-14".rev = "ca1871dd33649f27257a0fbf94076acc80ecffbc";
  propagatedBuildInputs = [ iris ];
  meta = {
    description = "Named props for Iris";
    maintainers = with lib.maintainers; [ ineol ];
  };
}
