{ lib, mkCoqDerivation, coq, version ? null }:

with lib; mkCoqDerivation {
  pname = "bignums";
  owner = "coq";
  displayVersion = { bignums = ""; };
  inherit version;
  defaultVersion = if versions.isGe "8.6" coq.coq-version
    then "${coq.coq-version}.0" else null;

  release."8.16.0".sha256 = "sha256-DH3iWwatPlhhCVYVlgL2WLkvneSVzSXUiKo2e0+1zR4=";
  release."8.15.0".sha256 = "093klwlhclgyrba1iv18dyz1qp5f0lwiaa7y0qwvgmai8rll5fns";
  release."8.14.0".sha256 = "0jsgdvj0ddhkls32krprp34r64y1rb5mwxl34fgaxk2k4664yq06";
  release."8.13.0".sha256 = "1n66i7hd9222b2ks606mak7m4f0dgy02xgygjskmmav6h7g2sx7y";
  release."8.12.0".sha256 = "14ijb3qy2hin3g4djx437jmnswxxq7lkfh3dwh9qvrds9a015yg8";
  release."8.11.0".sha256 = "1xcd7c7qlvs0narfba6px34zq0mz8rffnhxw0kzhhg6i4iw115dp";
  release."8.10.0".sha256 = "0bpb4flckn4nqxbs3wjiznyx1k7r8k93qdigp3qwmikp2lxvcbw5";
  release."8.9.0".sha256  = "03qz1w2xb2j5p06liz5yyafl0fl9vprcqm6j0iwi7rxwghl00p01";
  release."8.8.0".sha256  = "1ymxyrvjygscxkfj3qkq66skl3vdjhb670rzvsvgmwrjkrakjnfg";
  release."8.7.0".sha256  = "11c4sdmpd3l6jjl4v6k213z9fhrmmm1xnly3zmzam1wrrdif4ghl";
  release."8.6.0".rev     = "v8.6.0";
  release."8.6.0".sha256  = "0553pcsy21cyhmns6k9qggzb67az8kl31d0lwlnz08bsqswigzrj";
  releaseRev = v: "V${v}";

  mlPlugin = true;

  meta = { license = licenses.lgpl2; };
}
