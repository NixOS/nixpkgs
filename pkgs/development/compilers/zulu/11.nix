{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-11-lts&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        zuluVersion = "11.74.15";
        jdkVersion = "11.0.24";
        hash =
          if enableJavaFX then
            "sha256-eP2BCD77uRmukd48+pDlIlhos9RjL9VYx8tpQdq2uNo="
          else
            "sha256-p6rA5pqZv2Sho+yW8IFJrAaaW72q766SLuOnRl/ZGLM=";
      };

      aarch64-linux = {
        zuluVersion = "11.74.15";
        jdkVersion = "11.0.24";
        hash =
          if enableJavaFX then
            "sha256-nAUjPk9gktO0UJk7gAKygq+ztSJY5wk+EoG1LgJidJ8="
          else
            "sha256-T0c+YwfEZcA3iJmBriyzxBM2SECcczG25XVApIlgM+E=";
      };

      x86_64-darwin = {
        zuluVersion = "11.74.15";
        jdkVersion = "11.0.24";
        hash =
          if enableJavaFX then
            "sha256-hanQw2FWbqsmGR1WixbM0BNWGeXmS2vt9tbaaEY7D1c="
          else
            "sha256-CH6pVui0PInHMt+AJOE0T2hrAmEcLFRJvmR4KZuanaw=";
      };

      aarch64-darwin = {
        zuluVersion = "11.74.15";
        jdkVersion = "11.0.24";
        hash =
          if enableJavaFX then
            "sha256-WbzpfPgoT3CTazKBnI1Fg+q+YQP6MwCWkon6VOeLZsA="
          else
            "sha256-+KxFgHbBDxN1O3NCAzqqBztxXveYAjrPFVuoFL/2dRQ=";
      };
    };
  }
  // removeAttrs args [ "callPackage" ]
)
