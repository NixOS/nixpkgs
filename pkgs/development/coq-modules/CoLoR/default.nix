{
  lib,
  mkCoqDerivation,
  coq,
  bignums,
  version ? null,
}:

mkCoqDerivation {
  pname = "color";
  owner = "fblanqui";
  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.version [
      {
        case = range "8.14" "8.19";
        out = "1.8.5";
      }
      {
        case = range "8.12" "8.16";
        out = "1.8.2";
      }
      {
        case = range "8.10" "8.11";
        out = "1.7.0";
      }
      {
        case = range "8.8" "8.9";
        out = "1.6.0";
      }
      {
        case = range "8.6" "8.7";
        out = "1.4.0";
      }
    ] null;

  release."1.8.5".sha256 = "sha256-zKAyj6rKAasDF+iKExmpVHMe2WwgAwv2j1mmiVAl7ys=";
  release."1.8.4".sha256 = "sha256-WlRiaLgnFFW5AY0z6EzdP1mevNe1GHsik6wULJLN4k0=";
  release."1.8.3".sha256 = "sha256-mMUzIorkQ6WWQBJLk1ioUNwAdDdGHJyhenIvkAjALVU=";
  release."1.8.2".sha256 = "sha256:1gvx5cxm582793vxzrvsmhxif7px18h9xsb2jljy2gkphdmsnpqj";
  release."1.8.1".sha256 = "0knhca9fffmyldn4q16h9265i7ih0h4jhcarq4rkn0wnn7x8w8yw";
  release."1.7.0".rev = "08b5481ed6ea1a5d2c4c068b62156f5be6d82b40";
  release."1.7.0".sha256 = "1w7fmcpf0691gcwq00lm788k4ijlwz3667zj40j5jjc8j8hj7cq3";
  release."1.6.0".rev = "328aa06270584b578edc0d2925e773cced4f14c8";
  release."1.6.0".sha256 = "07sy9kw1qlynsqy251adgi8b3hghrc9xxl2rid6c82mxfsp329sd";
  release."1.4.0".rev = "168c6b86c7d3f87ee51791f795a8828b1521589a";
  release."1.4.0".sha256 = "1d2whsgs3kcg5wgampd6yaqagcpmzhgb6a0hp6qn4lbimck5dfmm";

  propagatedBuildInputs = [ bignums ];
  enableParallelBuilding = false;

  meta = {
    homepage = "https://github.com/fblanqui/color";
    description = "CoLoR is a library of formal mathematical definitions and proofs of theorems on rewriting theory and termination whose correctness has been mechanically checked by the Coq proof assistant.";
    maintainers = with lib.maintainers; [
      jpas
      jwiegley
    ];
  };
}
