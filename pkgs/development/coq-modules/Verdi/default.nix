{ stdenv, fetchFromGitHub, coq, mathcomp, StructTact, InfSeqExt, Cheerios }:

let params =
  {
    "8.6" = {
      version = "20181102";
      rev = "25b79cf1be5527ab8dc1b8314fcee93e76a2e564";
      sha256 = "1vw47c37k5vaa8vbr6ryqy8riagngwcrfmb3rai37yi9xhdqg55z";
    };

    "8.7" = {
      version = "20181102";
      rev = "25b79cf1be5527ab8dc1b8314fcee93e76a2e564";
      sha256 = "1vw47c37k5vaa8vbr6ryqy8riagngwcrfmb3rai37yi9xhdqg55z";
    };

    "8.8" = {
      version = "20181102";
      rev = "25b79cf1be5527ab8dc1b8314fcee93e76a2e564";
      sha256 = "1vw47c37k5vaa8vbr6ryqy8riagngwcrfmb3rai37yi9xhdqg55z";
    };

    "8.9" = {
      version = "20181102";
      rev = "25b79cf1be5527ab8dc1b8314fcee93e76a2e564";
      sha256 = "1vw47c37k5vaa8vbr6ryqy8riagngwcrfmb3rai37yi9xhdqg55z";
    };
  };
  param = params."${coq.coq-version}";
in

stdenv.mkDerivation rec {
  name = "coq${coq.coq-version}-verdi-${param.version}";

  src = fetchFromGitHub {
    owner = "uwplse";
    repo = "verdi";
    inherit (param) rev sha256;
  };

  buildInputs = [
    coq coq.ocaml coq.camlp5 coq.findlib mathcomp StructTact InfSeqExt Cheerios
  ];
  enableParallelBuilding = true;

  buildPhase = "make -j$NIX_BUILD_CORES";
  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.6" "8.7" "8.8" "8.9" ];
 };
}
