{ lib, mkCoqDerivation, coq, bignums, version ? null }:

with lib; mkCoqDerivation {
  pname = "color";
  owner = "fblanqui";
  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    {case = range "8.10" "8.11"; out = "1.7.0"; }
    {case = range "8.8"  "8.9";  out = "1.6.0"; }
    {case = range "8.6"  "8.7";  out = "1.4.0"; }
  ] null;

  release."1.7.0".rev    = "08b5481ed6ea1a5d2c4c068b62156f5be6d82b40";
  release."1.7.0".sha256 = "1w7fmcpf0691gcwq00lm788k4ijlwz3667zj40j5jjc8j8hj7cq3";
  release."1.6.0".rev    = "328aa06270584b578edc0d2925e773cced4f14c8";
  release."1.6.0".sha256 = "07sy9kw1qlynsqy251adgi8b3hghrc9xxl2rid6c82mxfsp329sd";
  release."1.4.0".rev    = "168c6b86c7d3f87ee51791f795a8828b1521589a";
  release."1.4.0".sha256 = "1d2whsgs3kcg5wgampd6yaqagcpmzhgb6a0hp6qn4lbimck5dfmm";

  extraBuildInputs = [ bignums ];
  enableParallelBuilding = false;

  meta = {
    homepage = "http://color.inria.fr/";
    description = "CoLoR is a library of formal mathematical definitions and proofs of theorems on rewriting theory and termination whose correctness has been mechanically checked by the Coq proof assistant.";
    maintainers = with maintainers; [ jpas jwiegley ];
  };
}
