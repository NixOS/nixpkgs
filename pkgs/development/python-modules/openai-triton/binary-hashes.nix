# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "2.0.0" = {
    x86_64-linux-38 = {
      name = "triton-2.0.0-1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/triton-2.0.0-1-cp38-cp38-manylinux2014_x86_64.manylinux_2_17_x86_64.whl";
      hash = "sha256-nUl4KYt0/PWadf5x5TXAkrAjCIkzsvHfkz7DJhXkvu8=";
    };
    x86_64-linux-39 = {
      name = "triton-2.0.0-1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/triton-2.0.0-1-cp39-cp39-manylinux2014_x86_64.manylinux_2_17_x86_64.whl";
      hash = "sha256-dPEYwStDf7LKJeGgR1kXO1F1gvz0x74RkTMWx2QhNlY=";
    };
    x86_64-linux-310 = {
      name = "triton-2.0.0-1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/triton-2.0.0-1-cp310-cp310-manylinux2014_x86_64.manylinux_2_17_x86_64.whl";
      hash = "sha256-OIBu6WY/Sw981keQ6WxXk3QInlj0mqxKZggSGqVeJQU=";
    };
    x86_64-linux-311 = {
      name = "triton-2.0.0-1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/triton-2.0.0-1-cp311-cp311-manylinux2014_x86_64.manylinux_2_17_x86_64.whl";
      hash = "sha256-ImlBx7hZUhnd71mh/bgh6MdEKJoTJBXd1YT6zt60dbE=";
    };
  };
}
