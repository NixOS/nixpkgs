{ stdenv, fetchFromGitHub, coq, Cheerios, InfSeqExt, ssreflect }:

let param =
  {
      version = "20181102";
      rev = "25b79cf1be5527ab8dc1b8314fcee93e76a2e564";
      sha256 = "1vw47c37k5vaa8vbr6ryqy8riagngwcrfmb3rai37yi9xhdqg55z";
  };
in

stdenv.mkDerivation rec {
  name = "coq${coq.coq-version}-verdi-${param.version}";

  src = fetchFromGitHub {
    owner = "uwplse";
    repo = "verdi";
    inherit (param) rev sha256;
  };

  buildInputs = [ coq ];
  propagatedBuildInputs = [ Cheerios InfSeqExt ssreflect ];

  enableParallelBuilding = true;

  preConfigure = "patchShebangs ./configure";

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  passthru = {
    compatibleCoqVersions = v: stdenv.lib.versionAtLeast v "8.6";
 };
}
