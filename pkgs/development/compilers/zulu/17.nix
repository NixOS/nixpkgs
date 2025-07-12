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
        zuluVersion = "17.52.17";
        jdkVersion = "17.0.12";
        hash =
          if enableJavaFX then
            "sha256-qKpkvk7/IEnlOJoy7An0AVGUXWkWeuuiQzqKKE/+Ec4="
          else
            "sha256-JCRcjQzkkV2G5wsoi13psbTHjxCtuw5rqT4pEAOarRk=";
      };

      aarch64-linux = {
        zuluVersion = "17.52.17";
        jdkVersion = "17.0.12";
        hash =
          if enableJavaFX then
            "sha256-mpTM/43oyDsOnoZM8AW1Z7EFTznnPAnYoC+T6csc8Fw="
          else
            "sha256-uIz2D5WjqySy5lobuvWp3kFTGsBKhXzT56QgCGyXwSY=";
      };

      x86_64-darwin = {
        zuluVersion = "17.52.17";
        jdkVersion = "17.0.12";
        hash =
          if enableJavaFX then
            "sha256-jb1oPmRzlYUMONovdsHowlC44X3/PFZ8KilxSsR924U="
          else
            "sha256-8VlGFUhCn3NE2A42xi69KzZqu0RoGOV1ZYj8oaqCnTc=";
      };

      aarch64-darwin = {
        zuluVersion = "17.52.17";
        jdkVersion = "17.0.12";
        hash =
          if enableJavaFX then
            "sha256-rEILTKTpX8DEoOGhlrhbxpcCyF2+QrjW92h0ox9ezp0="
          else
            "sha256-RZ3hNQQFE+spTT9lFHLjmkolSkpHDg2Hvro6xi7uNww=";
      };
    };
  }
  // builtins.removeAttrs args [ "callPackage" ]
)
