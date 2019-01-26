{ stdenv, fetchFromGitHub, coq }:

let params =
  {
    "8.6" = {
      version = "20180221";
      rev = "e1eee1f10d5d46331a560bd8565ac101229d0d6b";
      sha256 = "0l9885nxy0n955fj1gnijlxl55lyxiv9yjfmz8hmfrn9hl8vv1m2";
    };

    "8.7" = {
      version = "20180221";
      rev = "e1eee1f10d5d46331a560bd8565ac101229d0d6b";
      sha256 = "0l9885nxy0n955fj1gnijlxl55lyxiv9yjfmz8hmfrn9hl8vv1m2";
    };

    "8.8" = {
      version = "20180221";
      rev = "e1eee1f10d5d46331a560bd8565ac101229d0d6b";
      sha256 = "0l9885nxy0n955fj1gnijlxl55lyxiv9yjfmz8hmfrn9hl8vv1m2";
    };
  };
  param = params."${coq.coq-version}";
in

stdenv.mkDerivation rec {
  name = "coq${coq.coq-version}-Velisarios-${param.version}";

  src = fetchFromGitHub {
    owner = "vrahli";
    repo = "Velisarios";
    inherit (param) rev sha256;
  };

  buildInputs = [
    coq coq.ocaml coq.camlp5 coq.findlib
  ];
  enableParallelBuilding = true;

  buildPhase = "make -j$NIX_BUILD_CORES";
  preBuild = "./create-makefile.sh";
  installPhase = ''
    mkdir -p $out/lib/coq/${coq.coq-version}/Velisarios
    cp -pR model/*.vo $out/lib/coq/${coq.coq-version}/Velisarios
  '';

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.6" "8.7" "8.8" ];
 };
}
