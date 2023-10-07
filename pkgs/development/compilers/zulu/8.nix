{ callPackage
, enableJavaFX ? false
, ...
}@args:

callPackage ./common.nix ({
  # Details from https://www.azul.com/downloads/?version=java-8-lts&package=jdk
  # Note that the latest build may differ by platform
  dists = {
    x86_64-linux = {
      zuluVersion = "8.72.0.17";
      jdkVersion = "8.0.382";
      hash =
        if enableJavaFX then "sha256-mIPCFESU7hy2naYur2jvFBtVn/LZQRcFiyiG61buCYs="
        else "sha256-exWlbyrgBb7aD4daJps9qtFP+hKWkwbMdFR4OFslupY=";
    };

    x86_64-darwin = {
      zuluVersion = "8.72.0.17";
      jdkVersion = "8.0.382";
      hash =
        if enableJavaFX then "sha256-/x8FqygivzddXsOwIV8aj/u+LPXMmokgu97vLAVEv80="
        else "sha256-3dTPIPGUeT6nb3gncNvEa4VTRyQIBJpp8oZadrT2ToE=";
    };

    aarch64-darwin = {
      zuluVersion = "8.72.0.17";
      jdkVersion = "8.0.382";
      hash =
        if enableJavaFX then "sha256-FkQ+0MzSZWUzc/HmiDVZEHGOrdKAVCdK5pm9wXXzzaU="
        else "sha256-rN5AI4xAWppE4kJlzMod0JmGyHdHjTXYtx8/wOW6CFk=";
    };
  };
} // builtins.removeAttrs args [ "callPackage" ])
