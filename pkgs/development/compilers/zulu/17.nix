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
        zuluVersion = "17.64.17";
        jdkVersion = "17.0.18";
        hash =
          if enableJavaFX then
            "sha256-jQ2ByIKtivoc9nJ/LPMZCktyjceqXY+B6a36sXmwUbE="
          else
            "sha256-gZ4/CepiiQGiGyEE7Y9SVuF66RpBRbJysushMfgyrx0=";
      };

      aarch64-linux = {
        zuluVersion = "17.64.17";
        jdkVersion = "17.0.18";
        hash =
          if enableJavaFX then
            "sha256-ciyywX9R72RRt6HPfdmmsgFo/0ebr2xzNhnroAEDT7E="
          else
            "sha256-21fcnh+CIsL47604yMo2CxAR2Ln7m+oJVths1157Lb0=";
      };

      x86_64-darwin = {
        zuluVersion = "17.64.17";
        jdkVersion = "17.0.18";
        hash =
          if enableJavaFX then
            "sha256-td551xWmeHcD26J0gxboKS6Y3f5iLRhcUy97pfxhHxk="
          else
            "sha256-mHVhWicg6xAn8BaT4uCN93ChT8gYSYAfX7h7kRgdqyI=";
      };

      aarch64-darwin = {
        zuluVersion = "17.64.17";
        jdkVersion = "17.0.18";
        hash =
          if enableJavaFX then
            "sha256-TnN+tPJ8HJSlZ0EUDq5SHo40EviO0iMX0P9eYHyRVP4="
          else
            "sha256-EiRGuK028dyAZ3Jy29rXH9XKjXbfd0wB54Oce/TSZ9Y=";
      };
    };
  }
  // removeAttrs args [ "callPackage" ]
)
