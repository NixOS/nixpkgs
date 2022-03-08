{ lib, mkCoqDerivation, which, autoconf,
  coq, ssreflect, version ? null }:

with lib; mkCoqDerivation {
  pname = "coquelicot";
  owner = "coquelicot";
  domain = "gitlab.inria.fr";
  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = isGe "8.8" ;        out = "3.2.0"; }
    { case = range "8.8" "8.13"; out = "3.1.0"; }
    { case = range "8.5" "8.9";  out = "3.0.2"; }
  ] null;
  release."3.2.0".sha256 = "07w7dbl8x7xxnbr2q39wrdh054gvi3daqjpdn1jm53crsl1fjxm4";
  release."3.1.0".sha256 = "02i0djar13yk01hzaqprcldhhscn9843x9nf6x3jkv4wv1jwnx9f";
  release."3.0.2".sha256 = "1rqfbbskgz7b1bcpva8wh3v3456sq2364y804f94sc8y5sij23nl";
  releaseRev = v: "coquelicot-${v}";

  extraNativeBuildInputs = [ which autoconf ];
  propagatedBuildInputs = [ ssreflect ];
  useMelquiondRemake.logpath = "Coquelicot";

  meta = {
    homepage = "http://coquelicot.saclay.inria.fr/";
    description = "A Coq library for Reals";
    license = licenses.lgpl3;
    maintainers = [ maintainers.vbgl ];
  };
}
