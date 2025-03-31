{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-23-lts&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        zuluVersion = "24.28.83";
        jdkVersion = "24+36";
        hash =
          if enableJavaFX then
            "sha256-0EQ0lxHsoyHG+ZWIlWsbkqMf/rauARafzWoiElRwekA="
          else
            "sha256-01YPqBMaWkoruNFoSckLyx00LCOZNsowlSn2L3XCDJA=";
      };

      aarch64-linux = {
        zuluVersion = "24.28.83";
        jdkVersion = "24+36";
        hash =
          if enableJavaFX then
            throw "JavaFX is not available for aarch64-linux"
          else
            "sha256-0i+ch7BMAwMQ1C4e3shp9BHuQ67vVXfmIK1YKs7L24M=";
      };

      x86_64-darwin = {
        zuluVersion = "24.28.83";
        jdkVersion = "24+36";
        hash =
          if enableJavaFX then
            "sha256-00YmLWA/men8jMjnhkZVMf2irf6Tc/5x7UECxqKJcL4="
          else
            "sha256-0Er8M3KF9Z95gV8sHqi5lQD2RJjtssZx8Q8goy6danw=";
      };

      aarch64-darwin = {
        zuluVersion = "24.28.83";
        jdkVersion = "24+36";
        hash =
          if enableJavaFX then
            "sha256-0umPJoHmvklMlcpF4PFY/Arcdc5fkX5z0xeIuNFxluQ="
          else
            "sha256-0FvfJL0RQgIOATLTMdfa+fStUCrdHYC3rxy0j5eNVDc=";
      };
    };
  }
  // builtins.removeAttrs args [ "callPackage" ]
)
