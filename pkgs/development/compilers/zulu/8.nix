{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-8-lts&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        zuluVersion = "8.80.0.17";
        jdkVersion = "8.0.422";
        hash =
          if enableJavaFX then
            "sha256-Ls2sHCtP9htBIDwq5fNDRA3/bGN0bzaMp6nNkjU1zx8="
          else
            "sha256-YNxnNOFvTc0S3jt4F3UREi2196W7wSBmwieNJl7qamo=";
      };

      aarch64-linux = {
        zuluVersion = "8.80.0.17";
        jdkVersion = "8.0.422";
        hash =
          if enableJavaFX then
            "sha256-aVBleFrj4OpUJh82rM8XQGy9SzGqjaeOBo20nAbtpJo="
          else
            "sha256-C5ebWtKAyKexOuEf4yM1y5tQZ2ICxREObwvMrcz5TXE=";
      };

      x86_64-darwin = {
        zuluVersion = "8.80.0.17";
        jdkVersion = "8.0.422";
        hash =
          if enableJavaFX then
            "sha256-7NB0OH194nZdpIGyX8gLxJzjJdi2UIxmGsGI5M0yqJ4="
          else
            "sha256-vyB1Fepnpwsi9KjwFjEF+YbiCgmqZcirZu0zmRAp8PA=";
      };

      aarch64-darwin = {
        zuluVersion = "8.80.0.17";
        jdkVersion = "8.0.422";
        hash =
          if enableJavaFX then
            "sha256-JuQkY923tizx5HQo4WC3YCk75a4qHJYNRFKpZ8XES58="
          else
            "sha256-Q/hU2ICVwmJehrXmACm4/X48ULTqM6WSc55JDVgkBvM=";
      };
    };
  }
  // removeAttrs args [ "callPackage" ]
)
