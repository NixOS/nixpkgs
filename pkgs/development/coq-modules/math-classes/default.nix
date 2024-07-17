{
  lib,
  mkCoqDerivation,
  coq,
  bignums,
  version ? null,
}:

mkCoqDerivation {

  pname = "math-classes";
  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.coq-version [
      {
        case = range "8.17" "8.19";
        out = "8.19.0";
      }
      {
        case = range "8.12" "8.18";
        out = "8.18.0";
      }
      {
        case = range "8.12" "8.17";
        out = "8.17.0";
      }
      {
        case = range "8.6" "8.16";
        out = "8.15.0";
      }
    ] null;
  release."8.12.0".sha256 = "14nd6a08zncrl5yg2gzk0xf4iinwq4hxnsgm4fyv07ydbkxfb425";
  release."8.13.0".sha256 = "1ln7ziivfbxzbdvlhbvyg3v30jgblncmwcsam6gg3d1zz6r7cbby";
  release."8.15.0".sha256 = "10w1hm537k6jx8a8vghq1yx12rsa0sjk2ipv3scgir71ln30hllw";
  release."8.17.0".sha256 = "sha256-WklL8pgYTd0l4TGt7h7tWj1qcFcXvoPn25+XKF1pIKA=";
  release."8.18.0".sha256 = "sha256-0WwPss8+Vr37zX616xeuS4TvtImtSbToFQkQostIjO8=";
  release."8.19.0".sha256 = "sha256-rsV96W9MPFi/DKsepNPm1QnC2DMemio+uALIgzVYw0w=";

  propagatedBuildInputs = [ bignums ];

  meta = {
    homepage = "https://math-classes.github.io";
    description = "A library of abstract interfaces for mathematical structures in Coq.";
    maintainers = with lib.maintainers; [
      siddharthist
      jwiegley
    ];
  };
}
