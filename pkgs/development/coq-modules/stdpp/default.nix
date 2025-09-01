{
  lib,
  mkCoqDerivation,
  coq,
  stdlib,
  version ? null,
}:

mkCoqDerivation {
  pname = "stdpp";
  inherit version;
  domain = "gitlab.mpi-sws.org";
  owner = "iris";
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    with lib.versions;
    lib.switch coq.coq-version [
      (case (range "8.19" "9.1") "1.12.0")
      (case (range "8.18" "8.19") "1.10.0")
      (case (range "8.16" "8.18") "1.9.0")
      (case (range "8.13" "8.17") "1.8.0")
      (case (range "8.12" "8.14") "1.6.0")
      (case (range "8.11" "8.13") "1.5.0")
      (case (range "8.8" "8.10") "1.4.0")
    ] null;
  release."1.12.0".sha256 = "sha256-2o8YMkKbXrKHwtfpkdAovxl+2NZZk958GjSSd9wcEIU=";
  release."1.11.0".sha256 = "sha256-yqnkaA5gUdZBJZ3JnvPYh11vKQRl0BAnior1yGowG7k=";
  release."1.10.0".sha256 = "sha256-bfynevIKxAltvt76lsqVxBmifFkzEhyX8lRgTKxr21I=";
  release."1.9.0".sha256 = "sha256-OXeB+XhdyzWMp5Karsz8obp0rTeMKrtG7fu/tmc9aeI=";
  release."1.8.0".sha256 = "sha256-VkIGBPHevHeHCo/Q759Q7y9WyhSF/4SMht4cOPuAXHU=";
  release."1.7.0".sha256 = "sha256:0447wbzm23f9rl8byqf6vglasfn6c1wy6cxrrwagqjwsh3i5lx8y";
  release."1.6.0".sha256 = "1l1w6srzydjg0h3f4krrfgvz455h56shyy2lbcnwdbzjkahibl7v";
  release."1.5.0".sha256 = "1ym0fy620imah89p8b6rii8clx2vmnwcrbwxl3630h24k42092nf";
  release."1.4.0".sha256 = "1m6c7ibwc99jd4cv14v3r327spnfvdf3x2mnq51f9rz99rffk68r";
  releaseRev = v: "coq-stdpp-${v}";

  propagatedBuildInputs = [ stdlib ];

  preBuild = ''
    if [[ -f coq-lint.sh ]]
    then patchShebangs coq-lint.sh
    fi
  '';

  meta = with lib; {
    description = "Extended “Standard Library” for Coq";
    license = licenses.bsd3;
    maintainers = [
      maintainers.vbgl
      maintainers.ineol
    ];
  };
}
