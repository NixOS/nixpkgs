{ lib, mkCoqDerivation, coq, version ? null }:

with lib; mkCoqDerivation rec {
  pname = "stdpp";
  inherit version;
  domain = "gitlab.mpi-sws.org";
  owner = "iris";
  defaultVersion = with versions; switch coq.coq-version [
    { case = range "8.13" "8.16"; out = "1.7.0"; }
    { case = range "8.12" "8.14"; out = "1.6.0"; }
    { case = range "8.11" "8.13"; out = "1.5.0"; }
    { case = range "8.8" "8.10";  out = "1.4.0"; }
  ] null;
  release."1.7.0".sha256 = "sha256:0447wbzm23f9rl8byqf6vglasfn6c1wy6cxrrwagqjwsh3i5lx8y";
  release."1.6.0".sha256 = "1l1w6srzydjg0h3f4krrfgvz455h56shyy2lbcnwdbzjkahibl7v";
  release."1.5.0".sha256 = "1ym0fy620imah89p8b6rii8clx2vmnwcrbwxl3630h24k42092nf";
  release."1.4.0".sha256 = "1m6c7ibwc99jd4cv14v3r327spnfvdf3x2mnq51f9rz99rffk68r";
  releaseRev = v: "coq-stdpp-${v}";

  preBuild = ''
    if [[ -f coq-lint.sh ]]
    then patchShebangs coq-lint.sh
    fi
  '';

  meta = {
    description = "An extended “Standard Library” for Coq";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
