{ lib, bash, which, autoconf, automake,
  mkCoqDerivation, coq, version ? null }:

with lib; mkCoqDerivation {
  pname = "flocq";
  owner = "flocq";
  domain = "gitlab.inria.fr";
  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = isGe "8.7";        out = "3.3.1"; }
    { case = range "8.5" "8.8"; out = "2.6.1"; }
  ] null;
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
