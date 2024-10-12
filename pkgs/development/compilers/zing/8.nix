{ callPackage }:
callPackage ./common.nix {
  dists = {
    aarch64-linux = {
      version = "24.03.0.0";
      jdkVersion = "8.0.402";
      url =
        "https://cdn.azul.com/zing-zvm/ZVM24.03.0.0/zing24.03.0.0-4-jdk8.0.402-linux_aarch64.tar.gz";
      hash =
        "sha512-57WS7wGmX5Orcklko4expMgCQq/6rQhw5DTPmpJIcNcn01TX0eR3P3uQgQ2CzAHjCbkpBdyfQ3PdDb7qepc2bQ==";
    };
    x86_64-linux = {
      version = "24.03.0.0";
      jdkVersion = "8.0.402";
      url =
        "https://cdn.azul.com/zing-zvm/ZVM24.03.0.0/zing24.03.0.0-4-jdk8.0.402-linux_x64.tar.gz";
      hash =
        "sha512-Y1KguQ9OePTm+KWbhXVf/VhARwm8WX4jccsXEz6jDtyeJbyM26iRpVutAWnvQvW/K37vBT2ppyzUDqeZHKFJtw==";
    };
  };
}
