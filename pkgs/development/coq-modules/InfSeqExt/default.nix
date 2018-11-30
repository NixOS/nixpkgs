{ stdenv, fetchFromGitHub, coq, mathcomp }:

let params =
  {
    "8.5" = {
      version = "20180918";
      rev = "243d6be45666da73a9da6c37d451327165275798";
      sha256 = "1nh2psb4pcppy1akk24ilb4p08m35cba357i4xyymmarmbwqpxmn";
    };

    "8.6" = {
      version = "20180918";
      rev = "243d6be45666da73a9da6c37d451327165275798";
      sha256 = "1nh2psb4pcppy1akk24ilb4p08m35cba357i4xyymmarmbwqpxmn";
    };

    "8.7" = {
      version = "20180918";
      rev = "243d6be45666da73a9da6c37d451327165275798";
      sha256 = "1nh2psb4pcppy1akk24ilb4p08m35cba357i4xyymmarmbwqpxmn";
    };

    "8.8" = {
      version = "20180918";
      rev = "243d6be45666da73a9da6c37d451327165275798";
      sha256 = "1nh2psb4pcppy1akk24ilb4p08m35cba357i4xyymmarmbwqpxmn";
    };

    "8.9" = {
      version = "20180918";
      rev = "243d6be45666da73a9da6c37d451327165275798";
      sha256 = "1nh2psb4pcppy1akk24ilb4p08m35cba357i4xyymmarmbwqpxmn";
    };
  };
  param = params."${coq.coq-version}";
in

stdenv.mkDerivation rec {
  name = "coq${coq.coq-version}-InfSeqExt-${param.version}";

  src = fetchFromGitHub {
    owner = "DistributedComponents";
    repo = "InfSeqExt";
    inherit (param) rev sha256;
  };

  buildInputs = [
    coq coq.ocaml coq.camlp5 coq.findlib mathcomp
  ];
  enableParallelBuilding = true;

  buildPhase = "make -j$NIX_BUILD_CORES";
  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.5" "8.6" "8.7" "8.8" "8.9" ];
 };
}
