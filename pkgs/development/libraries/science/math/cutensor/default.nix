{ callPackage
, cudatoolkit_10_1
, cudatoolkit_10_2
, cudatoolkit_11
, cudatoolkit_11_0
, cudatoolkit_11_1
, cudatoolkit_11_2
, cudatoolkit_11_3
, cudatoolkit_11_4
, cudatoolkit_11_5
, cudatoolkit_11_6
}:

rec {
  cutensor_cudatoolkit_10_1 = callPackage ./generic.nix rec {
    version = "1.2.2.5";
    libPath = "lib/10.1";
    cudatoolkit = cudatoolkit_10_1;
    # 1.2.2 is compatible with CUDA 10.1, 10.2, and 11.x.
    # See https://docs.nvidia.com/cuda/cutensor/release_notes.html#cutensor-v1-2-2.
    hash = "sha256-lU7iK4DWuC/U3s1Ct/rq2Gr3w4F2U7RYYgpmF05bibY=";
  };

  cutensor_cudatoolkit_10_2 = cutensor_cudatoolkit_10_1.override {
    version = "1.3.1.3";
    libPath = "lib/10.2";
    cudatoolkit = cudatoolkit_10_2;
    # 1.3.1 is compatible with CUDA 10.2 and 11.x.
    # See https://docs.nvidia.com/cuda/cutensor/release_notes.html#cutensor-v1-3-1.
    hash = "sha256-mNlVnabB2IC3HnYY0mb06RLqQzDxN9ePGVeBy3hkBC8=";
  };

  cutensor_cudatoolkit_10 = cutensor_cudatoolkit_10_2;

  cutensor_cudatoolkit_11_0 = cutensor_cudatoolkit_10_2.override {
    libPath = "lib/11";
    cudatoolkit = cudatoolkit_11_0;
  };

  cutensor_cudatoolkit_11_1 = cutensor_cudatoolkit_11_0.override { cudatoolkit = cudatoolkit_11_1; };
  cutensor_cudatoolkit_11_2 = cutensor_cudatoolkit_11_0.override { cudatoolkit = cudatoolkit_11_2; };
  cutensor_cudatoolkit_11_3 = cutensor_cudatoolkit_11_0.override { cudatoolkit = cudatoolkit_11_3; };
  cutensor_cudatoolkit_11_4 = cutensor_cudatoolkit_11_0.override { cudatoolkit = cudatoolkit_11_4; };
  cutensor_cudatoolkit_11_5 = cutensor_cudatoolkit_11_0.override { cudatoolkit = cudatoolkit_11_5; };
  cutensor_cudatoolkit_11_6 = cutensor_cudatoolkit_11_0.override { cudatoolkit = cudatoolkit_11_6; };

  cutensor_cudatoolkit_11 = cutensor_cudatoolkit_11_0.override { cudatoolkit = cudatoolkit_11; };
}
