{
  coq,
  mkCoqDerivation,
  mathcomp,
  mathcomp-real-closed,
  lib,
  version ? null,
}:

mkCoqDerivation {

  namePrefix = [
    "coq"
    "mathcomp"
  ];
  pname = "abel";
  owner = "math-comp";

  inherit version;
  defaultVersion =
    with lib.versions;
    let
      cmc = c: mc: [
        c
        mc
      ];
    in
    lib.switch [ coq.coq-version mathcomp.version ] (lib.lists.sort (x: y: isLe x.out y.out) (
      lib.mapAttrsToList (out: cases: { inherit cases out; }) {
        "1.2.1" = cmc (range "8.10" "8.16") (range "1.12.0" "1.15.0");
        "1.2.0" = cmc (range "8.10" "8.15") (range "1.12.0" "1.14.0");
        "1.1.2" = cmc (range "8.10" "8.14") (range "1.11.0" "1.12.0");
      }
    )) null;

  release."1.2.1".sha256 = "sha256-M1q6WIPBsayHde2hwlTxylH169hcTs3OuFsEkM0e3yc=";
  release."1.2.0".sha256 = "1picd4m85ipj22j3b84cv8ab3330radzrhd6kp0gpxq14dhv02c2";
  release."1.1.2".sha256 = "0565w713z1cwxvvdlqws2z5lgdys8lddf0vpwfdj7bpd7pq9hwxg";
  release."1.0.0".sha256 = "190jd8hb8anqsvr9ysr514pm5sh8qhw4030ddykvwxx9d9q6rbp3";

  propagatedBuildInputs = [
    mathcomp.field
    mathcomp-real-closed
  ];

  meta = with lib; {
    description = "Abel - Galois and Abel - Ruffini Theorems";
    license = licenses.cecill-b;
    maintainers = [ maintainers.cohencyril ];
  };
}
