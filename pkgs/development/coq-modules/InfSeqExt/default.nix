{ stdenv, fetchFromGitHub, coq }:

let param =
  {
      version = "20180918";
      rev = "243d6be45666da73a9da6c37d451327165275798";
      sha256 = "1nh2psb4pcppy1akk24ilb4p08m35cba357i4xyymmarmbwqpxmn";
  };
in

stdenv.mkDerivation rec {
  name = "coq${coq.coq-version}-InfSeqExt-${param.version}";

  src = fetchFromGitHub {
    owner = "DistributedComponents";
    repo = "InfSeqExt";
    inherit (param) rev sha256;
  };

  buildInputs = [ coq ];

  enableParallelBuilding = true;

  preConfigure = "patchShebangs ./configure";

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  passthru = {
    compatibleCoqVersions = v: stdenv.lib.versionAtLeast v "8.5";
 };
}
