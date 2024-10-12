{ callPackage }:
callPackage ./common.nix {
  dists = {
    aarch64-linux = {
      version = "24.03.0.0";
      jdkVersion = "17.0.10";
      url =
        "https://cdn.azul.com/zing-zvm/ZVM24.03.0.0/zing24.03.0.0-4-jdk17.0.10-linux_aarch64.tar.gz";
      hash =
        "sha512-+SQCN2oLrUvEyFiNqv9WOyaO210tyqoFa1XeMzFQnJnBPGrq0KEH3bBm8HPlqGWk9JG1JKOLO3170hZDVXfxHA==";
    };
    x86_64-linux = {
      version = "24.03.0.0";
      jdkVersion = "17.0.10";
      url =
        "https://cdn.azul.com/zing-zvm/ZVM24.03.0.0/zing24.03.0.0-4-jdk17.0.10-linux_x64.tar.gz";
      hash =
        "sha512-yWB+paYvyj5EmSEE5dDKXwMbu+mH/s2DoZoYAdbFhZcABdIsqp76HTd4MmUJPMfGyecjeyvyKjReg9UD83RaJA==";
    };
  };
}
