{ callPackage
, enableJavaFX ? false
, stdenv
, ...
}@args:

callPackage ./common.nix ({
  # Details from https://www.azul.com/downloads/?version=java-8-lts&os=macos&package=jdk
  # Note that the latest build may differ by platform
  dist = {
    x86_64-darwin = {
      arch = "x64";
      zuluVersion = "8.72.0.17";
      jdkVersion = "8.0.382";
      hash =
        if enableJavaFX then "sha256-/x8FqygivzddXsOwIV8aj/u+LPXMmokgu97vLAVEv80="
        else "sha256-3dTPIPGUeT6nb3gncNvEa4VTRyQIBJpp8oZadrT2ToE=";
    };

    aarch64-darwin = {
      arch = "aarch64";
      zuluVersion = "8.72.0.17";
      jdkVersion = "8.0.382";
      hash =
        if enableJavaFX then "sha256-FkQ+0MzSZWUzc/HmiDVZEHGOrdKAVCdK5pm9wXXzzaU="
        else "sha256-rN5AI4xAWppE4kJlzMod0JmGyHdHjTXYtx8/wOW6CFk=";
    };
  }."${stdenv.hostPlatform.system}";
} // builtins.removeAttrs args [ "callPackage" ])
