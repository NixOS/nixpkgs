{
  lib,
  mkCoqDerivation,
  coq,
  bignums,
  version ? null,
}:

mkCoqDerivation {

  pname = "coqprime";
  owner = "thery";
  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.coq-version [
      {
        case = range "8.14" "8.20";
        out = "8.18";
      }
      {
        case = range "8.12" "8.16";
        out = "8.15";
      }
      {
        case = range "8.10" "8.11";
        out = "8.10";
      }
      {
        case = range "8.8" "8.9";
        out = "8.8";
      }
      {
        case = "8.7";
        out = "8.7.2";
      }
    ] null;

  release."8.18".sha256 = "sha256-KObBEYerWhIStmq90G3vs9K5LUEOfB2SPxirwLiWQ6E=";
  release."8.17".sha256 = "sha256-D878t/PijVCopRKHYqfwdNvt3arGlI8yxbK/vI6qZUY=";
  release."8.15".sha256 = "sha256:1zr2q52r08na8265019pj9spcz982ivixk6cnzk6l1srn2g328gv";
  release."8.14.1".sha256 = "sha256:0dqf87xkzcpg7gglbxjyx68ad84w1w73icxgy3s7d3w563glc2p7";
  release."8.12".sha256 = "1slka4w0pya15js4drx9frj7lxyp3k2lzib8v23givzpnxs8ijdj";
  release."8.10".sha256 = "0r9gnh5a5ykiiz5h1i8xnzgiydpwc4z9qhndxyya85xq0f910qaz";
  release."8.8".sha256 = "075yjczk79pf1hd3lgdjiz84ilkzfxjh18lgzrhhqp7d3kz5lxp5";
  release."8.7.2".sha256 = "15zlcrx06qqxjy3nhh22wzy0rb4npc8l4nx2bbsfsvrisbq1qb7k";
  releaseRev = v: "v${v}";

  mlPlugin = true; # uses coq-bignums.plugin

  propagatedBuildInputs = [ bignums ];

  meta = with lib; {
    description = "Library to certify primality using Pocklington certificate and Elliptic Curve Certificate";
    license = licenses.lgpl21;
    maintainers = [ maintainers.vbgl ];
  };
}
