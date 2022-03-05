{ which, lib, mkCoqDerivation, autoconf, coq, flocq, version ? null }:

with lib; mkCoqDerivation {
  pname = "gappalib";
  repo = "coq";
  owner = "gappa";
  domain = "gitlab.inria.fr";
  inherit version;
  defaultVersion = if versions.range "8.8" "8.14" coq.coq-version then "1.5.0" else null;
  release."1.5.0".sha256 = "1i1c0gakffxqqqqw064cbvc243yl325hxd50jmczr6mk18igk41n";
  release."1.4.5".sha256 = "081hib1d9wfm29kis390qsqch8v6fs3q71g2rgbbzx5y5cf48n9k";
  release."1.4.4".sha256 = "114q2hgw64j6kqa9mg3qcp1nlf0ia46z2xadq81fnkxqm856ml7l";
  releaseRev = v: "gappalib-coq-${v}";

  extraNativeBuildInputs = [ which autoconf ];
  mlPlugin = true;
  propagatedBuildInputs = [ flocq ];
  useMelquiondRemake.logpath = "Gappa";

  meta = {
    description = "Coq support library for Gappa";
    license = licenses.lgpl21;
    maintainers = [ maintainers.vbgl ];
  };
}
