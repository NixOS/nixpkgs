# Warning: use the same CUDA version as pytorch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "1.10.0" = {
    x86_64-linux-37 = {
      name = "torch-1.10.0-cp37-cp37m-linux_x86_64.whl";
      url =
        "https://download.pytorch.org/whl/cu113/torch-1.10.0%2Bcu113-cp37-cp37m-linux_x86_64.whl";
      hash = "sha256-KpDbklee2HXSqgrWr1U1nj8EJqUjBWp7SbACw8xtKtg=";
    };
    x86_64-linux-38 = {
      name = "torch-1.10.0-cp38-cp38-linux_x86_64.whl";
      url =
        "https://download.pytorch.org/whl/cu113/torch-1.10.0%2Bcu113-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-zM3cMriUG9A+3in/ChzOLytRETpe4ju4uXkxasIRQYM=";
    };
    x86_64-linux-39 = {
      name = "torch-1.10.0-cp39-cp39-linux_x86_64.whl";
      url =
        "https://download.pytorch.org/whl/cu113/torch-1.10.0%2Bcu113-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-w8UJDh4b5cgDu7ZSvDoKzNH4hiXEyRfvpycNOg+wJOg=";
    };
  };
}
