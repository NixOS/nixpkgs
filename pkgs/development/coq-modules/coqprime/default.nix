{ which, lib, mkCoqDerivation, coq, bignums, version ? null }:

with lib; mkCoqDerivation {

  pname = "coqprime";
  owner = "thery";
  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = range "8.12" "8.13"; out = "8.12"; }
    { case = range "8.10" "8.11"; out = "8.10"; }
    { case = range "8.8"  "8.9";  out = "8.8"; }
    { case = "8.7";               out = "8.7.2"; }
  ] null;

  release."8.12".sha256  = "1slka4w0pya15js4drx9frj7lxyp3k2lzib8v23givzpnxs8ijdj";
  release."8.10".sha256  = "0r9gnh5a5ykiiz5h1i8xnzgiydpwc4z9qhndxyya85xq0f910qaz";
  release."8.8".sha256   = "075yjczk79pf1hd3lgdjiz84ilkzfxjh18lgzrhhqp7d3kz5lxp5";
  release."8.7.2".sha256 = "15zlcrx06qqxjy3nhh22wzy0rb4npc8l4nx2bbsfsvrisbq1qb7k";
  releaseRev = v: "v${v}";

  extraBuildInputs = [ which ];
  propagatedBuildInputs = [ bignums ];

  meta = with lib; {
    description = "Library to certify primality using Pocklington certificate and Elliptic Curve Certificate";
    license = licenses.lgpl21;
    maintainers = [ maintainers.vbgl ];
  };
}
