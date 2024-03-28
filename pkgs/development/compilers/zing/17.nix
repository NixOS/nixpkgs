{ callPackage }:
callPackage ./common.nix {
  dists = {
    aarch64-linux = {
      version = "24.02.0.0";
      jdkVersion = "17.0.10";
      url =
        "https://cdn.azul.com/zing-zvm/ZVM24.02.0.0/zing24.02.0.0-6-jdk17.0.10-linux_aarch64.tar.gz";
      hash =
        "sha512-+FZu6BEd05lNvdR/fXr6jqrR9l9hqNfO3jRZgWyQLzOQ/21KslaBU3lM6Sd7sZpbMDdzJmBjhZx1g1nJXJg/pQ==";
    };
    x86_64-linux = {
      version = "24.02.0.0";
      jdkVersion = "17.0.10";
      url =
        "https://cdn.azul.com/zing-zvm/ZVM24.02.0.0/zing24.02.0.0-6-jdk17.0.10-linux_x64.tar.gz";
      hash =
        "sha512-4Gi52gLB175BKfojyLvqp7hSGP1BjIDf8q9xJYX5EYAdF4pPkn86Jk6VomWAOA9gQkumUEQ6/MLo1UsEl2OHZA==";
    };
  };
}
