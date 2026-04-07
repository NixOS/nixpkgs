let
  engineContentHash = "nixpkgs000000000000000000000000000000000";
in
{
  "gradle_wrapper.stamp" =
    "flutter_infra_release/gradle-wrapper/fd5c1f2c013565a3bea56ada6df9d2b8e96d56aa/gradle-wrapper.tgz";
  "ios-deploy.stamp" = "7a29ab0b6d611f2bf5de4b6f929a82a091866307";
  "libimobiledevice.stamp" = "0bf0f9e941c85d06ce4b5909d7a61b3a4f2a6a05";
  "libimobiledeviceglue.stamp" = "050ff3bf8fdab6ce53a2ddc6ae49b11b1c02a168";
  "libplist.stamp" = "cf5897a71ea412ea2aeb1e2f6b5ea74d4fabfd8c";
  "openssl.stamp" = "22dbb176deef7d9a80f5c94f57a4b518ea935f50";
  "material_fonts.stamp" =
    "flutter_infra_release/flutter/fonts/3012db47f3130e62f7cc0beabff968a33cbec8d8/fonts.zip";
  "libusbmuxd.stamp" = "19d6bec393c9f9b31ccb090059f59268da32e281";
  "android-internal-build-artifacts.stamp" = engineContentHash;
  "android-sdk.stamp" = engineContentHash;
  "engine-dart-sdk.stamp" = engineContentHash;
  "engine.stamp" = engineContentHash;
  "flutter_sdk.stamp" = engineContentHash;
  "flutter_web_sdk.stamp" = engineContentHash;
  "font-subset.stamp" = engineContentHash;
  "ios-sdk.stamp" = engineContentHash;
  "linux-sdk.stamp" = engineContentHash;
  "macos-sdk.stamp" = engineContentHash;
  "engine_stamp.stamp" = engineContentHash;
}
