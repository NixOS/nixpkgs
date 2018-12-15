{ stdenv, fetchFromGitHub, coq, StructTact }:

let params =
  {
    "8.6" = {
      version = "20181102";
      rev = "04da309304bdd28a1f7dacca9fdf8696204a4ff2";
      sha256 = "1xfa78p70c90favds1mv1vj5sr9bv0ad3dsgg05v3v72006g2f1q";
    };

    "8.7" = {
      version = "20181102";
      rev = "04da309304bdd28a1f7dacca9fdf8696204a4ff2";
      sha256 = "1xfa78p70c90favds1mv1vj5sr9bv0ad3dsgg05v3v72006g2f1q";
    };

    "8.8" = {
      version = "20181102";
      rev = "04da309304bdd28a1f7dacca9fdf8696204a4ff2";
      sha256 = "1xfa78p70c90favds1mv1vj5sr9bv0ad3dsgg05v3v72006g2f1q";
    };

    "8.9" = {
      version = "20181102";
      rev = "04da309304bdd28a1f7dacca9fdf8696204a4ff2";
      sha256 = "1xfa78p70c90favds1mv1vj5sr9bv0ad3dsgg05v3v72006g2f1q";
    };
  };
  param = params."${coq.coq-version}";
in

stdenv.mkDerivation rec {
  name = "coq${coq.coq-version}-Cheerios-${param.version}";

  src = fetchFromGitHub {
    owner = "uwplse";
    repo = "cheerios";
    inherit (param) rev sha256;
  };

  buildInputs = [
    coq coq.ocaml coq.camlp5 coq.findlib StructTact
  ];
  enableParallelBuilding = true;

  buildPhase = "make -j$NIX_BUILD_CORES";
  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.6" "8.7" "8.8" "8.9" ];
 };
}
