{ callPackage }:
callPackage ./common.nix {
  dists = {
    aarch64-linux = {
      version = "24.02.0.0";
      jdkVersion = "11.0.22";
      url =
        "https://cdn.azul.com/zing-zvm/ZVM24.02.0.0/zing24.02.0.0-6-jdk11.0.22-linux_aarch64.tar.gz";
      hash =
        "sha512-XRYyEIB8XAczRiUuW3Eha1vj3Ez0xlf4UKQOujAfwzK3fRsMVDjRUWUsbjs28oCIowXE2tYVeR08K6C65owPyg==";
    };
    x86_64-linux = {
      version = "24.02.0.0";
      jdkVersion = "11.0.22";
      url =
        "https://cdn.azul.com/zing-zvm/ZVM24.02.0.0/zing24.02.0.0-6-jdk11.0.22-linux_x64.tar.gz";
      hash =
        "sha512-5OepQcqZJXr6gqCEwXB/uhB344RNlmXaiP+eD5ZCbY+F52YrMr/Hd8VjC9KZl8eEkH9COTtSrxuAFOAB5qkZAg==";
    };
  };
}
