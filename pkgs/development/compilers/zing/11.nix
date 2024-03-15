{ callPackage }:
callPackage ./common.nix {
  dists = {
    aarch64-linux = {
      version = "24.03.0.0";
      jdkVersion = "11.0.22";
      url =
        "https://cdn.azul.com/zing-zvm/ZVM24.03.0.0/zing24.03.0.0-4-jdk11.0.22-linux_aarch64.tar.gz";
      hash =
        "sha512-m9CYtzktcXQUXxJ27XJnkltIss6TvS4KvhHRanAGA1SRhOZIyqrNrKzFZ5K7eDuKuapMy8N86Q5U7OBmj/xGGA==";
    };
    x86_64-linux = {
      version = "24.03.0.0";
      jdkVersion = "11.0.22";
      url =
        "https://cdn.azul.com/zing-zvm/ZVM24.03.0.0/zing24.03.0.0-4-jdk11.0.22-linux_x64.tar.gz";
      hash =
        "sha512-+Y+3Mc04bdjxploSUUon0A8T8pFpSwYpJjO25fD2c/u6RKEuScN6/ZSTPDPKSan7YhuW8R0aVAcNawRWrBojZw==";
    };
  };
}
