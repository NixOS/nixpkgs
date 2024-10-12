{ callPackage }:
callPackage ./common.nix {
  dists = {
    aarch64-linux = {
      version = "24.03.0.0";
      jdkVersion = "21.0.2";
      url =
        "https://cdn.azul.com/zing-zvm/ZVM24.03.0.0/zing24.03.0.0-4-jdk21.0.2-linux_aarch64.tar.gz";
      hash =
        "sha512-WN0Zk/LVSINaGEu0Y3/nMaVlsv1S1XJWYiNBQ7r2XAyUk+CRH5v9cN/asKBDJcU2GkMOAgz/ulvWqlkdDWa8RQ==";
    };
    x86_64-linux = {
      version = "24.03.0.0";
      jdkVersion = "21.0.2";
      url =
        "https://cdn.azul.com/zing-zvm/ZVM24.03.0.0/zing24.03.0.0-4-jdk21.0.2-linux_x64.tar.gz";
      hash =
        "sha512-wbdjYccAUBVyjI7QWZAL6QfwsS2J+sW2eTF1pGYGZSv8IUi+tosrMnZwgl8KLRGNh3RrWmse40Iapn++HTMHGQ==";
    };
  };
}
