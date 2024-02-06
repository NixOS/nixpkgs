{ callPackage
, enableJavaFX ? false
, ...
}@args:

callPackage ./common.nix ({
  # Details from https://www.azul.com/downloads/?version=java-16-sts&package=jdk
  # Note that the latest build may differ by platform
  dists = {
    x86_64-darwin = {
      zuluVersion = "16.32.15";
      jdkVersion = "16.0.2";
      hash =
        if enableJavaFX then "sha256-6URaSBNHQWLauO//kCuKXb4Z7AqyshWnoeJEyVRKgaY="
        else "sha256-NXgBj/KixTknaCYbo3B+rOo11NImH5CDUIU0LhTCtMo=";
    };

    aarch64-darwin = {
      zuluVersion = "16.32.15";
      jdkVersion = "16.0.2";
      hash =
        if enableJavaFX then "sha256-QuyhIAxUY3Vv1adGihW+LIsXtpDX2taCmFsMFj9o5vs="
        else "sha256-3bUfDcLLyahLeURFAgLAVapBZHvqtam8GHbWTA6MQog=";
    };
  };
} // builtins.removeAttrs args [ "callPackage" ])
