{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-17-lts&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        zuluVersion = "17.48.15";
        jdkVersion = "17.0.10";
        hash =
          if enableJavaFX then
            "sha256-YvuD/n84+DARPm+38TxIUB727SIhASFo+WX9+PtJqyw="
          else
            "sha256-VyhNob2G1Tq/WCKT0g0Y//f+JD2hWgj6QU9idfvUj+I=";
      };

      aarch64-linux = {
        zuluVersion = "17.48.15";
        jdkVersion = "17.0.10";
        hash =
          if enableJavaFX then
            throw "JavaFX is not available for aarch64-linux"
          else
            "sha256-9OZl8ruaLvjdpg42fC3IM5mC/9lmshCppNfUuz/Sf8E=";
      };

      x86_64-darwin = {
        zuluVersion = "17.48.15";
        jdkVersion = "17.0.10";
        hash =
          if enableJavaFX then
            "sha256-VOIcFtjQiYsA4AiP1TCa0Q76Ew5FdeJCICwsYGU+Dnw="
          else
            "sha256-huSKGvOnrEUAiE2MJbdHWtF2saeLGaQkZllXzDo8o+g=";
      };

      aarch64-darwin = {
        zuluVersion = "17.48.15";
        jdkVersion = "17.0.10";
        hash =
          if enableJavaFX then
            "sha256-fxBDhHMeL5IP4eRw9ykXrRRh7Nl9DnvDB1YLaQwFHLg="
          else
            "sha256-kuEiHSkb4WFtPB3m0A968LPZw7Wl0sKquhbzDF8vQS8=";
      };
    };
  }
  // builtins.removeAttrs args [ "callPackage" ]
)
