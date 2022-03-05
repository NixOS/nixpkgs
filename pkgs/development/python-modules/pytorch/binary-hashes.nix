# Warning: use the same CUDA version as pytorch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "1.10.0" = {
    x86_64-linux-37 = {
      name = "torch-1.10.0-cp37-cp37m-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu113/torch-1.10.0%2Bcu113-cp37-cp37m-linux_x86_64.whl";
      hash = "sha256-KpDbklee2HXSqgrWr1U1nj8EJqUjBWp7SbACw8xtKtg=";
    };
    x86_64-linux-38 = {
      name = "torch-1.10.0-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu113/torch-1.10.0%2Bcu113-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-zM3cMriUG9A+3in/ChzOLytRETpe4ju4uXkxasIRQYM=";
    };
    x86_64-linux-39 = {
      name = "torch-1.10.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu113/torch-1.10.0%2Bcu113-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-w8UJDh4b5cgDu7ZSvDoKzNH4hiXEyRfvpycNOg+wJOg=";
    };
    x86_64-darwin-37 = {
      name = "torch-1.10.0-cp37-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.10.0-cp37-none-macosx_10_9_x86_64.whl";
      hash = "sha256-RJkFVUcIfX736KdU8JwsTxRwKXrj5UkDY9umbHVQGyE=";
    };
    x86_64-darwin-38 = {
      name = "torch-1.10.0-cp38-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.10.0-cp38-none-macosx_10_9_x86_64.whl";
      hash = "sha256-rvevti6bF0tODl4eSkLjurO4SQpmjWZvYvfUUXVZ+/I=";
    };
    x86_64-darwin-39 = {
      name = "torch-1.10.0-cp39-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.10.0-cp39-none-macosx_10_9_x86_64.whl";
      hash = "sha256-1u+HRwtE35lw6EVCVH1bp3ILuJYWYCRB31VaObEk4rw=";
    };
    aarch64-darwin-38 = {
      name = "torch-1.10.0-cp38-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.10.0-cp38-none-macosx_11_0_arm64.whl";
      hash = "sha256-1hhYJ7KFeAZTzdgdd6Cf3KdqWxkNWYbVUr4qXEQs+qQ=";
    };
    aarch64-darwin-39 = {
      name = "torch-1.10.0-cp39-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.10.0-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-7qZ17AHsS0oGVf0phPFmpco7kz2uatTrTlLrpwJtwXY=";
    };
  };
}
