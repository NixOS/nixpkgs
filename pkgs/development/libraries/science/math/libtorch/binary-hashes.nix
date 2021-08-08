version: {
  x86_64-darwin-cpu = {
    url = "https://download.pytorch.org/libtorch/cpu/libtorch-macos-${version}.zip";
    hash = "sha256-TOJ+iQpqazta46y4IzIbfEGMjz/fz+pRDV8fKqriB6Q=";
  };
  x86_64-linux-cpu = {
    url = "https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-${version}%2Bcpu.zip";
    hash = "sha256-gZMNLCzW3j+eplBqWo6lVvuHS5iRqtMD8NL3MoszsVg=";
  };
  x86_64-linux-cuda = {
    url = "https://download.pytorch.org/libtorch/cu111/libtorch-cxx11-abi-shared-with-deps-${version}%2Bcu111.zip";
    hash = "sha256-dRu4F8k2SAbtghwrPJNyX0u3tsODCbXfi9EqUdf4xYc=";
  };
}
