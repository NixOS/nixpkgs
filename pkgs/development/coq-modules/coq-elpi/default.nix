{ lib, mkCoqDerivation, which, coq, version ? null }:

with builtins; with lib; let
  elpi = coq.ocamlPackages.elpi.override (lib.switch coq.coq-version [
    { case = "8.11"; out = { version = "1.11.4"; };}
    { case = "8.12"; out = { version = "1.12.0"; };}
    { case = "8.13"; out = { version = "1.13.0"; };}
  ] {});
in mkCoqDerivation {
  pname = "elpi";
  repo  = "coq-elpi";
  owner = "LPCIC";
  inherit version;
  defaultVersion = lib.switch coq.coq-version [
    { case = "8.13"; out = "1.9.5"; }
    { case = "8.12"; out = "1.8.2_8.12"; }
    { case = "8.11"; out = "1.6.2_8.11"; }
  ] null;
  release."1.9.5".sha256      = "0gjdwmb6bvb5gh0a6ra48bz5fb3pr5kpxijb7a8mfydvar5i9qr6";
  release."1.9.4".sha256      = "0nii7238mya74f9g6147qmpg6gv6ic9b54x5v85nb6q60d9jh0jq";
  release."1.9.3".sha256      = "198irm800fx3n8n56vx1c6f626cizp1d7jfkrc6ba4iqhb62ma0z";
  release."1.9.2".sha256      = "1rr2fr8vjkc0is7vh1461aidz2iwkigdkp6bqss4hhv0c3ijnn07";
  release."1.8.2_8.12".sha256  = "1n6jwcdazvjgj8vsv2r9zgwpw5yqr5a1ndc2pwhmhqfl04b5dk4y";
  release."1.8.2_8.12".version = "1.8.2";
  release."1.8.1".sha256      = "1fbbdccdmr8g4wwpihzp4r2xacynjznf817lhijw6kqfav75zd0r";
  release."1.8.0".sha256      = "13ywjg94zkbki22hx7s4gfm9rr87r4ghsgan23xyl3l9z8q0idd1";
  release."1.7.0".sha256      = "1ws5cqr0xawv69prgygbl3q6dgglbaw0vc397h9flh90kxaqgyh8";
  release."1.6.2_8.11".sha256 = "06xrx0ljilwp63ik2sxxr7h617dgbch042xfcnfpy5x96br147rn";
  release."1.6.2_8.11".version = "1.6.2";
  release."1.6.1_8.11".sha256 = "0yyyh35i1nb3pg4hw7cak15kj4y6y9l84nwar9k1ifdsagh5zq53";
  release."1.6.1_8.11".version = "1.6.1";
  release."1.6.0_8.11".sha256 = "0ahxjnzmd7kl3gl38kyjqzkfgllncr2ybnw8bvgrc6iddgga7bpq";
  release."1.6.0_8.11".version = "1.6.0";
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
