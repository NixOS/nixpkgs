# Warning: use the same CUDA version as pytorch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "1.9.1" = {
    x86_64-linux-37 = {
      name = "torch-1.9.1-cp37-cp37m-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu111/torch-1.9.1%2Bcu111-cp37-cp37m-linux_x86_64.whl";
      hash = "sha256-qzXbbpLX+ZlRv41oAyQRk3guU0n/6vuNzWw+nOieL6s=";
    };
    x86_64-linux-38 = {
      name = "torch-1.9.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu111/torch-1.9.1%2Bcu111-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-JUbcqugax08/iN1LKfXq0ohSpejmbKhbT0by7qMGAzw=";
    };
    x86_64-linux-39 = {
      name = "torch-1.9.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu111/torch-1.9.1%2Bcu111-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-wNLLtR9ZxKkVOTzwbAikM5H83pXyH+aPHVFyfrO4c1M=";
    };
  };
}
