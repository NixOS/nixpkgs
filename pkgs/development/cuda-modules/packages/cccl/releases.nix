# The CCCL release each cccl redistributable in the CUDA manifests was built from, read from CCCL_VERSION in its
# headers. CUDA 13.5's redistributable also has cuda::ptx wrappers for PTX ISA 9.5, which are in no public commit, so
# v3.5.0 lacks them.
{ fetchpatch }:
{
  "12.6.77" = {
    version = "2.5.0";
    hash = "sha256-4rIeweyaVIz1Z+2g0pTTZRSkYSNr5PClAPm2G95YJuw=";
  };
  "12.8.90" = {
    version = "2.7.0";
    hash = "sha256-rgvEVEdHLvvT0CEhRSM1Y6xSO4ca0Ekw9mjW4Es/w3E=";
  };
  "12.9.27" = {
    version = "2.8.2";
    hash = "sha256-gF0SyS/BOr+ZnFVabFnRdzhim/Xx+ZXjWFWFXsM541s=";
    patches = [
      # Fix missing _CCCL_PP_SPLICE_WITH_IMPL20 in preprocessor.h
      # https://github.com/NVIDIA/cccl/issues/4967
      # https://github.com/NVIDIA/cccl/pull/4972
      (fetchpatch {
        name = "fix-missing-_CCCL_PP_SPLICE_WITH_IMPL20";
        url = "https://github.com/NVIDIA/cccl/commit/2c2276d8b19d737cb16811ce2eb761030f472e60.patch";
        hash = "sha256-bTECDc7P5sBHSffa/fP1Uu/yP/r+M2hbgTNTh0FLmoU=";
      })
    ];
  };
  "13.0.85" = {
    version = "3.0.1";
    hash = "sha256-KZtvyVRXpUtIgN0xmVlDVkVJF1tl6Xd/uGiu3reF5pI=";
  };
  "13.1.115" = {
    version = "3.1.4";
    hash = "sha256-5uhQAP9jqSq9maUnHsh9SSTMOWERHUKkhf9TvUNVDsE=";
  };
  "13.2.86" = {
    version = "3.2.0";
    hash = "sha256-tvrJQeK7z65i7l3nb58++QyO3cc8lBu/VIeLvCfRLVo=";
    patches = [
      # Fix onnxruntime compilation error: https://github.com/microsoft/onnxruntime/issues/28023
      # Backport: https://github.com/NVIDIA/cccl/pull/8771
      (fetchpatch {
        name = "fix-invalid-cpp-syntax";
        url = "https://github.com/NVIDIA/cccl/commit/8e41eeabe54ab9ae48ad5640cfa7153b0a1071af.patch";
        hash = "sha256-OQC/uTlTdqCF5a70cv225/p+sr4chHrNoHzE6wHJ3MA=";
      })
    ];
  };
  "13.3.3.4.1" = {
    version = "3.3.4";
    hash = "sha256-f+GUqCfulOzpytMAcfshD2oWVAw5GEoGSohKXAYEUCc=";
  };
  "13.3.4.3.1" = {
    version = "3.4.3";
    hash = "sha256-/qoLUeHUAaj+auoA1ScfIAGCX8UsND2Q98Fytrd3t2s=";
    patches = [
      # cuda::make_tma_descriptor checks the outermost box dimension instead of the innermost against the 16-byte
      # requirement, rejecting valid descriptors; fixed in CCCL 3.5.0.
      # Backport: https://github.com/NVIDIA/cccl/pull/10546
      (fetchpatch {
        name = "fix-make_tma_descriptor";
        url = "https://github.com/NVIDIA/cccl/commit/c95095c8d5faf1d8e978057a4f5cc0c27bccab70.patch";
        hash = "sha256-3j/mT9hzqGf7dK7v+pQkPxhF92RipncuHhoTatvACE0=";
      })
    ];
  };
  "13.3.5.0.6" = {
    version = "3.5.0";
    hash = "sha256-DqX/KyBZOr1NjBb+fPgM2+OuF6n0oq2eYakCpONuOfo=";
  };
}
