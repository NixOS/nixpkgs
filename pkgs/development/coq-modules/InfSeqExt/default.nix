{ stdenv, fetchFromGitHub, coq }:

let param =
  {
      version = "20200131";
      rev = "203d4c20211d6b17741f1fdca46dbc091f5e961a";
      sha256 = "0xylkdmb2dqnnqinf3pigz4mf4zmczcbpjnn59g5g76m7f2cqxl0";
  };
in

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-InfSeqExt-${param.version}";

  src = fetchFromGitHub {
    owner = "DistributedComponents";
    repo = "InfSeqExt";
    inherit (param) rev sha256;
  };

  buildInputs = [ coq ];

  enableParallelBuilding = true;

  preConfigure = "patchShebangs ./configure";

  installFlags = [ "COQLIB=$(out)/lib/coq/${coq.coq-version}/" ];

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.5" "8.6" "8.7" "8.8" "8.9" "8.10" "8.11" ];
 };
}
