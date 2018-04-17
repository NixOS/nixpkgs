{ callPackage, cudatoolkit7, cudatoolkit75, cudatoolkit8, cudatoolkit9 }:

let
  generic = args: callPackage (import ./generic.nix (removeAttrs args ["cudatoolkit"])) {
    inherit (args) cudatoolkit;
  };

in

{
  cudnn_cudatoolkit7 = generic rec {
    version = "4.0";
    cudatoolkit = cudatoolkit7;
    srcName = "cudnn-${cudatoolkit.majorVersion}-linux-x64-v${version}-prod.tgz";
    sha256 = "0zgr6qdbc29qw6sikhrh6diwwz7150rqc8a49f2qf37j2rvyyr2f";
  };

  cudnn_cudatoolkit75 = generic rec {
    version = "6.0";
    cudatoolkit = cudatoolkit75;
    srcName = "cudnn-${cudatoolkit.majorVersion}-linux-x64-v${version}.tgz";
    sha256 = "0b68hv8pqcvh7z8xlgm4cxr9rfbjs0yvg1xj2n5ap4az1h3lp3an";
  };

  cudnn6_cudatoolkit8 = generic rec {
    version = "6.0";
    cudatoolkit = cudatoolkit8;
    srcName = "cudnn-${cudatoolkit.majorVersion}-linux-x64-v${version}.tgz";
    sha256 = "173zpgrk55ri8if7s5yngsc89ajd6hz4pss4cdxlv6lcyh5122cv";
  };

  cudnn_cudatoolkit8 = generic rec {
    version = "7.0.5";
    cudatoolkit = cudatoolkit8;
    srcName = "cudnn-${cudatoolkit.majorVersion}-linux-x64-v7.tgz";
    sha256 = "9e0b31735918fe33a79c4b3e612143d33f48f61c095a3b993023cdab46f6d66e";
  };

  cudnn_cudatoolkit9 = generic rec {
    version = "7.0.5";
    cudatoolkit = cudatoolkit9;
    srcName = "cudnn-${cudatoolkit.majorVersion}-linux-x64-v7.tgz";
    sha256 = "1rfmdd2v47p83fm3sfyvik31gci0q17qs6kjng6mvcsd6akmvb8y";
  };
}
