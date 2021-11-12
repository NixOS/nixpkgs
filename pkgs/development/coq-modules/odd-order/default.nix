{ lib, mkCoqDerivation, mathcomp, version ? null }:
with lib;

mkCoqDerivation {
  pname = "odd-order";
  owner = "math-comp";

  release."1.12.0".rev    = "mathcomp-odd-order.1.12.0";
  release."1.12.0".sha256 = "sha256-omsfdc294CxKAHNMMeqJCcVimvyRCHgxcQ4NJOWSfNM=";

  inherit version;
  defaultVersion = with versions; switch mathcomp.character.version [
    { case = (range "1.10.0" "1.12.0"); out = "1.12.0"; }
  ] null;

  propagatedBuildInputs = [ mathcomp.character ];

  meta = {
    description = "Formal proof of the Odd Order Theorem";
    maintainers = with maintainers; [ siraben ];
    license = licenses.cecill-b;
    platforms = platforms.unix;
  };
}
