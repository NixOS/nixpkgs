{ stdenv, fetchFromGitHub, coq }:

let params = {
      "8.6" = {
        rev = "v8.6.0";
        sha256 = "0553pcsy21cyhmns6k9qggzb67az8kl31d0lwlnz08bsqswigzrj";
      };
      "8.7" = {
        rev = "V8.7.0";
        sha256 = "11c4sdmpd3l6jjl4v6k213z9fhrmmm1xnly3zmzam1wrrdif4ghl";
      };
      "8.8" = {
        rev = "V8.8.0";
        sha256 = "1ymxyrvjygscxkfj3qkq66skl3vdjhb670rzvsvgmwrjkrakjnfg";
      };
      "8.9" = {
        rev = "V8.9.0";
        sha256 = "03qz1w2xb2j5p06liz5yyafl0fl9vprcqm6j0iwi7rxwghl00p01";
      };
      "8.10" = {
        rev = "V8.10+beta1";
        sha256 = "1slw227idwjw9a21vj3s6kal22mrmvvlpg8r7xk590ml99bn6404";
      };
    };
    param = params.${coq.coq-version};
in

stdenv.mkDerivation {

  name = "coq${coq.coq-version}-bignums";

  src = fetchFromGitHub {
    owner = "coq";
    repo = "bignums";
    inherit (param) rev sha256;
  };

  buildInputs = with coq.ocamlPackages; [ ocaml camlp5 findlib coq ];

  installFlags = [ "COQLIB=$(out)/lib/coq/${coq.coq-version}/" ];

  meta = with stdenv.lib; {
    license = licenses.lgpl2;
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.hasAttr v params;
  };
}
