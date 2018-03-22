{ stdenv, fetchFromGitHub, coq }:

let param =
  {
    "8.6" = {
      rev = "v8.6.0";
      sha256 = "0553pcsy21cyhmns6k9qggzb67az8kl31d0lwlnz08bsqswigzrj";
    };
    "8.7" = {
      rev = "V8.7.0";
      sha256 = "11c4sdmpd3l6jjl4v6k213z9fhrmmm1xnly3zmzam1wrrdif4ghl";
    };
  }."${coq.coq-version}"
; in

stdenv.mkDerivation rec {

  name = "coq${coq.coq-version}-bignums";

  src = fetchFromGitHub {
    owner = "coq";
    repo = "bignums";
    inherit (param) rev sha256;
  };

  buildInputs = [ coq.ocaml coq.camlp5 coq.findlib coq ];

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = with stdenv.lib; {
    license = licenses.lgpl2;
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.6" "8.7" ];
  };
}
