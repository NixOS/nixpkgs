{ callPackage, cudatoolkit8, cudatoolkit9 }:

let
  generic = args: callPackage (import ./generic.nix (removeAttrs args ["cudatoolkit"])) {
    inherit (args) cudatoolkit;
  };

in

{
  nccl_cudatoolkit8 = generic rec {
    version = "2.1.4";
    cudatoolkit = cudatoolkit8;
    srcName = "nccl_${version}-1+cuda${cudatoolkit.majorVersion}_x86_64.txz";
    sha256 = "1lwwm8kdhna5m318yg304kl2gsz1jwhv4zv4gn8av2m57zh848zi";
  };

  nccl_cudatoolkit9 = generic rec {
    version = "2.1.4";
    cudatoolkit = cudatoolkit9;
    srcName = "nccl_${version}-1+cuda${cudatoolkit.majorVersion}_x86_64.txz";
    sha256 = "0pajmqzkacpszs63jh2hw2qqc49kj75kcf7r0ky8hdh560q8xn0p";
  };
}
