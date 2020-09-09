{ stdenv, fetchFromGitHub, coq, Cheerios, InfSeqExt, ssreflect }:

let param =
  if stdenv.lib.versionAtLeast coq.coq-version "8.7" then
  {
      version = "20200131";
      rev = "fdb4ede19d2150c254f0ebcfbed4fb9547a734b0";
      sha256 = "1a2k19f9q5k5djbxplqmmpwck49kw3lrm3aax920h4yb40czkd8m";
  } else {
      version = "20181102";
      rev = "25b79cf1be5527ab8dc1b8314fcee93e76a2e564";
      sha256 = "1vw47c37k5vaa8vbr6ryqy8riagngwcrfmb3rai37yi9xhdqg55z";
  };
in

stdenv.mkDerivation {
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

  installFlags = [ "COQLIB=$(out)/lib/coq/${coq.coq-version}/" ];

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.6" "8.7" "8.8" "8.9" "8.10" "8.11" ];
 };
}
