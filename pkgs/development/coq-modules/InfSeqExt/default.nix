{ lib, mkCoqDerivation, coq, version ? null }:

mkCoqDerivation {
  pname = "InfSeqExt";
  owner = "DistributedComponents";
  inherit version;
  defaultVersion = if lib.versions.isGe "8.5" coq.version then "20200131" else null;
  release."20200131".rev    = "203d4c20211d6b17741f1fdca46dbc091f5e961a";
  release."20200131".sha256 = "0xylkdmb2dqnnqinf3pigz4mf4zmczcbpjnn59g5g76m7f2cqxl0";
  preConfigure = "patchShebangs ./configure";
}
