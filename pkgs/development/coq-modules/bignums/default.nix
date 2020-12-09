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
        rev = "V8.10.0";
        sha256 = "0bpb4flckn4nqxbs3wjiznyx1k7r8k93qdigp3qwmikp2lxvcbw5";
      };
      "8.11" = {
        rev = "V8.11.0";
        sha256 = "1xcd7c7qlvs0narfba6px34zq0mz8rffnhxw0kzhhg6i4iw115dp";
      };
      "8.12" = {
        rev = "V8.12.0";
        sha256 = "14ijb3qy2hin3g4djx437jmnswxxq7lkfh3dwh9qvrds9a015yg8";
      };
      "8.13" = {
        rev = "V8.13.0";
        sha256 = "1n66i7hd9222b2ks606mak7m4f0dgy02xgygjskmmav6h7g2sx7y";
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

  buildInputs = with coq.ocamlPackages; [ ocaml findlib coq ]
  ++ stdenv.lib.optional (!stdenv.lib.versionAtLeast coq.coq-version "8.10") camlp5
  ;

  installFlags = [ "COQLIB=$(out)/lib/coq/${coq.coq-version}/" ];

  meta = with stdenv.lib; {
    license = licenses.lgpl2;
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.hasAttr v params;
  };
}
