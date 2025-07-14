{
  lib,
  mkCoqDerivation,
  autoconf,
  coq,
  flocq,
  version ? null,
}:

mkCoqDerivation {
  pname = "gappalib";
  repo = "coq";
  owner = "gappa";
  domain = "gitlab.inria.fr";
  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.coq-version [
      {
        case = range "8.16" "8.20";
        out = "1.7.0";
      }
      {
        case = range "8.8" "8.15";
        out = "1.5.5";
      }
    ] null;

  release."1.7.0".sha256 = "sha256-NHKfX2on0tw2T0AqOLIFDCHlkl9OXkLiRExEwauwGqE=";
  release."1.6.0".sha256 = "sha256-GQls31TT4y3h18RUxAX+LpHIKon5UvDfW1GuURRKeKA=";
  release."1.5.5".sha256 = "sha256-qxi2Kg3N3o6+ncq7aPNEg98dBmQC5WCa86zROPJSDdo=";
  release."1.5.4".sha256 = "sha256-9PlkXqCu4rbFD7qnMF1GSpPCVmwJ3r593RfAvkJbbdA=";
  release."1.5.3".sha256 = "sha256-SuMopX5sm4jh2uBuE7zr6vhWhHYZYnab+epjqYJqg+s=";
  release."1.5.2".sha256 = "sha256-A021Bhqz5r2CZBayfjIiWrCIfUlejcQAfbTmOaf6QTM=";
  release."1.5.1".sha256 = "1806bq1z6q5rq2ma7d5kfbqfyfr755hjg0dq7b2llry8fx9cxjsg";
  release."1.5.0".sha256 = "1i1c0gakffxqqqqw064cbvc243yl325hxd50jmczr6mk18igk41n";
  release."1.4.5".sha256 = "081hib1d9wfm29kis390qsqch8v6fs3q71g2rgbbzx5y5cf48n9k";
  release."1.4.4".sha256 = "114q2hgw64j6kqa9mg3qcp1nlf0ia46z2xadq81fnkxqm856ml7l";
  releaseRev = v: "gappalib-coq-${v}";

  nativeBuildInputs = [ autoconf ];
  mlPlugin = true;
  propagatedBuildInputs = [ flocq ];
  useMelquiondRemake.logpath = "Gappa";

  meta = with lib; {
    description = "Coq support library for Gappa";
    license = licenses.lgpl21;
    maintainers = [ maintainers.vbgl ];
  };
}
