{ callPackage
, enableJavaFX ? false
, ...
}@args:

callPackage ./common.nix ({
  # Details from https://www.azul.com/downloads/?version=java-21-lts&package=jdk
  # Note that the latest build may differ by platform
  dists = {
    x86_64-linux = {
      zuluVersion = "21.28.85";
      jdkVersion = "21.0.0";
      hash =
        if enableJavaFX then "sha256-ew/tgSdkrPdk1CTguk9nyl30w7se+YZYqyqOTaeketk="
        else "sha256-DA6t+9xHp8pkrqtRucBh9xtuTSXS2HZ0US6bY4fp46Y=";
    };

    aarch64-linux = {
      zuluVersion = "21.28.85";
      jdkVersion = "21.0.0";
      hash =
        if enableJavaFX then throw "JavaFX is not available for aarch64-linux"
        else "sha256-H7ZLgDbF1GPYq1mvBr9bawBoEeYBLjsOtrzPV/HFWDU=";
    };

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
