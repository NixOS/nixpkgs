{ callPackage
, enableJavaFX ? false
, ...
}@args:

callPackage ./common.nix ({
  # Details from https://www.azul.com/downloads/?version=java-21-lts&package=jdk
  # Note that the latest build may differ by platform
  dists = {
    x86_64-darwin = {
      zuluVersion = "21.28.85";
      jdkVersion = "21.0.0";
      hash =
        if enableJavaFX then "sha256-QrgEpLaNGc2aNFF38z2ckUTCpweKnuALYLOWATZFJPA="
        else "sha256-ljm4fbWG0MifepiSrkf0IeRCxkuXuuvf8xeI++IyZb0=";
    };

    aarch64-darwin = {
      zuluVersion = "21.28.85";
      jdkVersion = "21.0.0";
      hash =
        if enableJavaFX then "sha256-PUVB/R1K1dLTi1FsOYIvcI76M6EYYeMG1Bm+oMno//Y="
        else "sha256-KnqZo+omPb2NMqZ9Hm42O6iyXGRcgm9eFnoCu6+v8fo=";
    };
  };
} // builtins.removeAttrs args [ "callPackage" ])
