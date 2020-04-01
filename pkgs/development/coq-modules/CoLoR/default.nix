{ stdenv, fetchFromGitHub, coq, bignums }:

let
  coqVersions = {
    "8.6" = "1.4.0";
    "8.7" = "1.4.0";
    "8.8" = "1.6.0";
    "8.9" = "1.6.0";
    "8.10" = "1.7.0";
  };
  params = {
    "1.4.0" = {
      version = "1.4.0";
      rev = "168c6b86c7d3f87ee51791f795a8828b1521589a";
      sha256 = "1d2whsgs3kcg5wgampd6yaqagcpmzhgb6a0hp6qn4lbimck5dfmm";
    };
    "1.6.0" = {
      version = "1.6.0";
      rev = "328aa06270584b578edc0d2925e773cced4f14c8";
      sha256 = "07sy9kw1qlynsqy251adgi8b3hghrc9xxl2rid6c82mxfsp329sd";
    };
    "1.7.0" = {
      version = "1.7.0";
      rev = "08b5481ed6ea1a5d2c4c068b62156f5be6d82b40";
      sha256 = "1w7fmcpf0691gcwq00lm788k4ijlwz3667zj40j5jjc8j8hj7cq3";
    };
  };
  param = params.${coqVersions.${coq.coq-version}};
in

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-CoLoR-${param.version}";

  src = fetchFromGitHub {
    owner = "fblanqui";
    repo = "color";
    inherit (param) rev sha256;
  };

  buildInputs = [ coq bignums ];
  enableParallelBuilding = false;

  installPhase = ''
    make -f Makefile.coq COQLIB=$out/lib/coq/${coq.coq-version}/ install
  '';

  meta = with stdenv.lib; {
    homepage = http://color.inria.fr/;
    description = "CoLoR is a library of formal mathematical definitions and proofs of theorems on rewriting theory and termination whose correctness has been mechanically checked by the Coq proof assistant.";
    maintainers = with maintainers; [ jpas jwiegley ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.hasAttr v coqVersions;
  };
}
