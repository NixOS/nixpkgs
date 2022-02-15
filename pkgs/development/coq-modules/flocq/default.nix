{ lib, bash, which, autoconf, automake,
  mkCoqDerivation, coq, version ? null }:

with lib; mkCoqDerivation {
  pname = "flocq";
  owner = "flocq";
  domain = "gitlab.inria.fr";
  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = range "8.7" "8.15"; out = "3.4.3"; }
    { case = range "8.5" "8.8"; out = "2.6.1"; }
  ] null;
  release."3.4.3".sha256 = "sha256-YTdWlEmFJjCcHkl47jSOgrGqdXoApJY4u618ofCaCZE=";
  release."3.4.2".sha256 = "1s37hvxyffx8ccc8mg5aba7ivfc39p216iibvd7f2cb9lniqk1pw";
  release."3.3.1".sha256 = "1mk8adhi5hrllsr0hamzk91vf2405sjr4lh5brg9201mcw11abkz";
  release."2.6.1".sha256 = "0q5a038ww5dn72yvwn5298d3ridkcngb1dik8hdyr3xh7gr5qibj";
  releaseRev = v: "flocq-${v}";

  nativeBuildInputs = [ bash which autoconf ];
  mlPlugin = true;
  useMelquiondRemake.logpath = "Flocq";

  meta = {
    description = "A floating-point formalization for the Coq system";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jwiegley ];
  };
}
