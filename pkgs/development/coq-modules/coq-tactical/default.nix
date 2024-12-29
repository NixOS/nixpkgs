{
  coq,
  lib,
  mkCoqDerivation,
  version ? null,
}:

mkCoqDerivation {
  pname = "coq-tactical";
  owner = "tchajed";

  inherit version;
  displayVersion.coq-tactical = v: "unstable-${v}";
  defaultVersion =
    with lib.versions;
    lib.switch coq.version [
      {
        case = range "8.11" "8.20";
        out = "2022-02-15";
      }
    ] null;

  release."2022-02-15" = {
    rev = "7c26f9a017395c240845184dfed23489d29dbae5";
    sha256 = "sha256-SNoQzGYw5tuabHUDwMAyUsAa/WNoYjmyR85b7a0hVl4=";
  };

  installPhase = ''
    COQLIB=$out/lib/coq/${coq.coq-version}
    mkdir -p $COQLIB/user-contrib/Tactical
    cp -pR src/* $COQLIB/user-contrib/Tactical
  '';

  meta = {
    description = "Library of Coq proof automation";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stepbrobd ];
  };
}
