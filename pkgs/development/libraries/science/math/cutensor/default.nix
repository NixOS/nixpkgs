{ callPackage
, cudatoolkit_10_1, cudatoolkit_10_2
, cudatoolkit_11_0, cudatoolkit_11_1, cudatoolkit_11_2
}:

rec {
  cutensor_cudatoolkit_10_1 = callPackage ./generic.nix rec {
    version = "1.2.2.5";
    libPath = "lib/10.1";
    cudatoolkit = cudatoolkit_10_1;
    # 1.2.2 is compatible with CUDA 11.0, 11.1, and 11.2:
    # ephemeral doc at https://developer.nvidia.com/cutensor/downloads
    sha256 = "1dl9bd71frhac9cb8lvnh71zfsnqxbxbfhndvva2zf6nh0my4klm";
  };

  cutensor_cudatoolkit_10_2 = cutensor_cudatoolkit_10_1.override {
    libPath = "lib/10.2";
    cudatoolkit = cudatoolkit_10_2;
  };

  cutensor_cudatoolkit_10 = cutensor_cudatoolkit_10_2;

  cutensor_cudatoolkit_11_0 = cutensor_cudatoolkit_10_2.override {
    libPath = "lib/11";
    cudatoolkit = cudatoolkit_11_0;
  };

  cutensor_cudatoolkit_11_1 = cutensor_cudatoolkit_11_0.override {
    cudatoolkit = cudatoolkit_11_1;
  };

  cutensor_cudatoolkit_11_2 = cutensor_cudatoolkit_11_0.override {
    cudatoolkit = cudatoolkit_11_2;
  };

  cutensor_cudatoolkit_11 = cutensor_cudatoolkit_11_2;
}
