{ lib, mkCoqDerivation, which, coq, version ? null }:

with builtins; with lib; let
  elpi = coq.ocamlPackages.elpi.override (
    optionalAttrs (coq.coq-version == "8.11") { version = "1.11.4"; }
  );
in mkCoqDerivation {
  pname = "elpi";
  repo  = "coq-elpi";
  owner = "LPCIC";
  inherit version;
  defaultVersion = lib.switch coq.coq-version [
    { case = "8.13"; out = "1.8.1"; }
    { case = "8.12"; out = "1.8.0"; }
    { case = "8.11"; out = "1.6.0_8.11"; }
  ] null;
  release."1.8.1".sha256      = "1fbbdccdmr8g4wwpihzp4r2xacynjznf817lhijw6kqfav75zd0r";
  release."1.8.0".sha256      = "13ywjg94zkbki22hx7s4gfm9rr87r4ghsgan23xyl3l9z8q0idd1";
  release."1.7.0".sha256      = "1ws5cqr0xawv69prgygbl3q6dgglbaw0vc397h9flh90kxaqgyh8";
  release."1.6.0_8.11".sha256 = "0ahxjnzmd7kl3gl38kyjqzkfgllncr2ybnw8bvgrc6iddgga7bpq";
  release."1.6.0".sha256      = "0kf99i43mlf750fr7fric764mm495a53mg5kahnbp6zcjcxxrm0b";
  releaseRev = v: "v${v}";

  nativeBuildInputs = [ which ];
  mlPlugin = true;
  extraBuildInputs = [ elpi ];

  meta = {
    description = "Coq plugin embedding ELPI.";
    maintainers = [ maintainers.cohencyril ];
    license = licenses.lgpl21;
  };
}
