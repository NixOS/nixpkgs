{ stdenv, fetchFromGitHub, coq, StructTact }:

let param =
  {
      version = "20181102";
      rev = "04da309304bdd28a1f7dacca9fdf8696204a4ff2";
      sha256 = "1xfa78p70c90favds1mv1vj5sr9bv0ad3dsgg05v3v72006g2f1q";
  };
in

stdenv.mkDerivation rec {
  name = "coq${coq.coq-version}-Cheerios-${param.version}";

  src = fetchFromGitHub {
    owner = "uwplse";
    repo = "cheerios";
    inherit (param) rev sha256;
  };

  buildInputs = [ coq ];

  propagatedBuildInputs = [ StructTact ];
  enableParallelBuilding = true;

  preConfigure = "patchShebangs ./configure";

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  passthru = {
    compatibleCoqVersions = v: stdenv.lib.versionAtLeast v "8.6";
 };
}
