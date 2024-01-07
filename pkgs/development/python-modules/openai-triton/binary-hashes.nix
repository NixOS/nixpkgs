# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "2.1.0" = {
    x86_64-linux-38 = {
      name = "triton-2.1.0-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/triton-2.1.0-0-cp38-cp38-manylinux2014_x86_64.manylinux_2_17_x86_64.whl";
      hash = "sha256-Ofb7a9zLPpjzFS4/vqck8a6ufXSUErux+pxEHUdOuiY=";
    };
    x86_64-linux-39 = {
      name = "triton-2.1.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/triton-2.1.0-0-cp39-cp39-manylinux2014_x86_64.manylinux_2_17_x86_64.whl";
      hash = "sha256-IVROUiwCAFpibIrWPTm9/y8x1BBpWSkZ7ygelk7SZEY=";
    };
    x86_64-linux-310 = {
      name = "triton-2.1.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/triton-2.1.0-0-cp310-cp310-manylinux2014_x86_64.manylinux_2_17_x86_64.whl";
      hash = "sha256-ZkOZI6MNXUg5mwip6uEDcPbCYaXshkpkmDuuYxUtOdc=";
    };
    x86_64-linux-311 = {
      name = "triton-2.1.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/triton-2.1.0-0-cp311-cp311-manylinux2014_x86_64.manylinux_2_17_x86_64.whl";
      hash = "sha256-kZsGRT8AM+pSwT6veDPeDlfbMXjSPU4E+fxxxPLDK/g=";
    };
  };
}
