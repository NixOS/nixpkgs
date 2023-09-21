{ lib, mkCoqDerivation, coq, version ? null }:

mkCoqDerivation {
  pname = "bignums";
  owner = "coq";
  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
    { case = range "8.13" "8.18"; out = "9.0.0+coq${coq.coq-version}"; }
    { case = range "8.6" "8.17"; out = "${coq.coq-version}.0"; }
  ] null;

  release."9.0.0+coq8.18".sha256 = "sha256-vLeJ0GNKl4M84Uj2tAwlrxJOSR6VZoJQvdlDhxJRge8=";
  release."9.0.0+coq8.17".sha256 = "sha256-Mn85LqxJKPDIfpxRef9Uh5POwOKlTQ7jsMVz1wnQwuY=";
  release."9.0.0+coq8.16".sha256 = "sha256-pwFTl4Unr2ZIirAB3HTtfhL2YN7G/Pg88RX9AhKWXbE=";
  release."9.0.0+coq8.15".sha256 = "sha256-2oGOANn3XULHNIlyqjZ5ppQTQa2QF1zzf3YjHAd/pjo=";
  release."9.0.0+coq8.14".sha256 = "sha256-qTU152Dz34W6nFZ0pPbja9ouUm/714ZrLQ/Z4N/HIC4=";
  release."9.0.0+coq8.13".sha256 = "sha256-zvAqV3VAB7cN+nlMhjSXzxuDkdd387ju2VSb2EUthI0=";
  release."8.17.0".sha256 = "sha256-MXYjqN86+3O4hT2ql62U83T5H03E/8ysH8erpvC/oyw=";
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
  releaseRev = v: "${if lib.versions.isGe "9.0" v then "v" else "V"}${v}";

  mlPlugin = true;

  meta = { license = lib.licenses.lgpl2; };
}
