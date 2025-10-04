{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

let
  # For Zulu 25, FX and non-FX versions can differ
  zuluVersion = if enableJavaFX then "25.28.85" else "25.28.85";
in
callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-24&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        inherit zuluVersion;
        jdkVersion = "25.0.0";
        hash =
          if enableJavaFX then
            "sha256-5Hhob86uCxrrdrFEvNaqPaQEaGrF47jpgUibKkNs1AQ="
          else
            "sha256-Fk2QHlokC4wYUW9atVvBH8lomrboKQRa6oRnNW3Ns0A=";
      };

      aarch64-linux = {
        inherit zuluVersion;
        jdkVersion = "25.0.0";
        hash =
          if enableJavaFX then
            "sha256-HmfKOh0X2jcLrEMmKV81nQebtOOJjzpHWe1Ca+qIFYI="
          else
            "sha256-tg651UyXukFZVHg0qYzF0BYoHdKz5g50dcukkRMkvLQ=";
      };

      x86_64-darwin = {
        inherit zuluVersion;
        jdkVersion = "25.0.0";
        hash =
          if enableJavaFX then
            "sha256-J5Akv28y3XoJgw5q2Rh4xHv1AV1I33jnPslhxDrTc0E="
          else
            "sha256-ws3h0xPZBLeTw3YCFO76IH7Mp98E58QISr3x9rvrwno=";
      };

      aarch64-darwin = {
        inherit zuluVersion;
        jdkVersion = "25.0.0";
        hash =
          if enableJavaFX then
            "sha256-urxxVoayeNW0g0g80eefmG+FMVzVBaBvmMKj+S3URNE="
          else
            "sha256-c/ZPa618PfMfunQPvLu+98Glzt7/u13zht15vHKrqbY=";
      };
    };
  }
  // builtins.removeAttrs args [ "callPackage" ]
)
