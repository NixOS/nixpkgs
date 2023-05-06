{ lib, mkCoqDerivation, autoconf,
  coq, ssreflect, version ? null }:

mkCoqDerivation {
  pname = "coquelicot";
  owner = "coquelicot";
  domain = "gitlab.inria.fr";
  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
    { case = range "8.12" "8.17"; out = "3.3.0"; }
    { case = range "8.8" "8.16"; out = "3.2.0"; }
    { case = range "8.8" "8.13"; out = "3.1.0"; }
    { case = range "8.5" "8.9";  out = "3.0.2"; }
  ] null;
  release."3.3.0".sha256 = "sha256-bh9qP/EhWrHpTe2GMGG3S2vgBSSK088mFfhAIGejVoU=";
  release."3.2.0".sha256 = "07w7dbl8x7xxnbr2q39wrdh054gvi3daqjpdn1jm53crsl1fjxm4";
  release."3.1.0".sha256 = "02i0djar13yk01hzaqprcldhhscn9843x9nf6x3jkv4wv1jwnx9f";
  release."3.0.2".sha256 = "1rqfbbskgz7b1bcpva8wh3v3456sq2364y804f94sc8y5sij23nl";
  releaseRev = v: "coquelicot-${v}";

  nativeBuildInputs = [ autoconf ];
  propagatedBuildInputs = [ ssreflect ];
  useMelquiondRemake.logpath = "Coquelicot";

  meta =  with lib; {
    homepage = "http://coquelicot.saclay.inria.fr/";
    description = "A Coq library for Reals";
    license = licenses.lgpl3;
    maintainers = [ maintainers.vbgl ];
  };
}
