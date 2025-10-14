{
  lib,
  mkCoqDerivation,
  autoconf,
  coq,
  stdlib,
  mathcomp-boot,
  version ? null,
}:

mkCoqDerivation {
  pname = "coquelicot";
  owner = "coquelicot";
  domain = "gitlab.inria.fr";
  inherit version;
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    with lib.versions;
    lib.switch coq.coq-version [
      (case (range "8.12" "9.1") "3.4.4")
      (case (range "8.12" "9.1") "3.4.3")
      (case (range "8.12" "8.20") "3.4.2")
      (case (range "8.12" "8.18") "3.4.0")
      (case (range "8.12" "8.17") "3.3.0")
      (case (range "8.8" "8.16") "3.2.0")
      (case (range "8.8" "8.13") "3.1.0")
      (case (range "8.5" "8.9") "3.0.2")
    ] null;
  release."3.4.4".sha256 = "sha256-xuL1ZpAfiBvQwXGjS7aN2N7KqSZlw+ywB8HvL9/Bjqs=";
  release."3.4.3".sha256 = "sha256-bzzAIENU2OYTtmdBU9Xw8zyBvz9vqTiqjWSm7RnXXRA=";
  release."3.4.2".sha256 = "sha256-aBTF8ZKu67Rb3ryCqFyejUXf/65KgG8i5je/ZMFSrj4=";
  release."3.4.1".sha256 = "sha256-REhvIBl3EaL8CQqI34Gn7Xjf9NhPI3nrUAO26pSLbm0=";
  release."3.4.0".sha256 = "sha256-LIj2SwTvVBxSAO58VYCQix/uxQQe8ey6hqFOSh3PNcg=";
  release."3.3.1".sha256 = "sha256-YCvd4aIt2BxLKBYSWzN7aqo0AuY7z8oADmKvybhYBQI=";
  release."3.3.0".sha256 = "sha256-bh9qP/EhWrHpTe2GMGG3S2vgBSSK088mFfhAIGejVoU=";
  release."3.2.0".sha256 = "07w7dbl8x7xxnbr2q39wrdh054gvi3daqjpdn1jm53crsl1fjxm4";
  release."3.1.0".sha256 = "02i0djar13yk01hzaqprcldhhscn9843x9nf6x3jkv4wv1jwnx9f";
  release."3.0.2".sha256 = "1rqfbbskgz7b1bcpva8wh3v3456sq2364y804f94sc8y5sij23nl";
  releaseRev = v: "coquelicot-${v}";

  nativeBuildInputs = [ autoconf ];
  propagatedBuildInputs = [
    stdlib
    mathcomp-boot
  ];
  useMelquiondRemake.logpath = "Coquelicot";

  meta = with lib; {
    homepage = "http://coquelicot.saclay.inria.fr/";
    description = "Coq library for Reals";
    license = licenses.lgpl3;
    maintainers = [ maintainers.vbgl ];
  };
}
