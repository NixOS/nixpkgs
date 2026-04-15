{
  lib,
  stdenv,
  constants,
  engineVersion,
  artifactHashes,
  useNixpkgsEngine,
  engines,
  fetchurl,
  hostPlatform ? stdenv.hostPlatform,
  supportedTargetFlutterPlatforms,
}:

let
  hostConstants = constants.makeConstants hostPlatform;

  engineBaseUrl = "https://storage.googleapis.com/flutter_infra_release/flutter/${engineVersion}/";
  baseUrl = "https://storage.googleapis.com/flutter_infra_release/";

  getUrl =
    path:
    if
      (
        lib.hasPrefix "flutter/" path
        || lib.hasPrefix "gradle-" path
        || lib.hasPrefix "ios-usb-dependencies" path
      )
    then
      baseUrl + path
    else
      engineBaseUrl + path;

  artifacts = {
    universal = [
      {
        path = "flutter/fonts/3012db47f3130e62f7cc0beabff968a33cbec8d8/fonts.zip";
        target = "bin/cache/artifacts/material_fonts";
        hash = "sha256-5W+o6btFif3pZL495FHz5bJR5KHq+x3JjZSt0DTdWoY=";
      }
      {
        path = "gradle-wrapper/fd5c1f2c013565a3bea56ada6df9d2b8e96d56aa/gradle-wrapper.tgz";
        target = "bin/cache/artifacts/gradle_wrapper";
        hash = "sha256-MelCi68aKy9IXxEQxYmfhSZJsz1Goumwf50XdS1QGQo=";
      }
      {
        path = "sky_engine.zip";
        target = "bin/cache/pkg";
      }
      {
        path = "flutter_gpu.zip";
        target = "bin/cache/pkg";
      }
      {
        path = "flutter_patched_sdk.zip";
        target = "bin/cache/artifacts/engine/common";
      }
      {
        path = "flutter_patched_sdk_product.zip";
        target = "bin/cache/artifacts/engine/common";
      }
      {
        path = "${hostPlatform.parsed.kernel.name}-${
          if hostPlatform.isWindows then "x64" else hostConstants.alt-arch
        }/artifacts.zip";
        target = "bin/cache/artifacts/engine/${hostPlatform.parsed.kernel.name}-${
          if (hostPlatform.isDarwin || hostPlatform.isWindows) then "x64" else hostConstants.alt-arch
        }";
      }
      {
        path = "${hostPlatform.parsed.kernel.name}-${
          if hostPlatform.isWindows then "x64" else hostConstants.alt-arch
        }/font-subset.zip";
        target = "bin/cache/artifacts/engine/${hostPlatform.parsed.kernel.name}-${
          if (hostPlatform.isDarwin || hostPlatform.isWindows) then "x64" else hostConstants.alt-arch
        }";
      }
    ];

    web = [
      {
        path = "flutter-web-sdk.zip";
        target = "bin/cache/flutter_web_sdk";
      }
    ];

    linux = [
      {
        path = "linux-${hostConstants.alt-arch}/artifacts.zip";
        target = "bin/cache/artifacts/engine/linux-${hostConstants.alt-arch}";
      }
      {
        path = "linux-${hostConstants.alt-arch}-debug/linux-${hostConstants.alt-arch}-flutter-gtk.zip";
        target = "bin/cache/artifacts/engine/linux-${hostConstants.alt-arch}";
      }
      {
        path = "linux-${hostConstants.alt-arch}-profile/linux-${hostConstants.alt-arch}-flutter-gtk.zip";
        target = "bin/cache/artifacts/engine/linux-${hostConstants.alt-arch}-profile";
      }
      {
        path = "linux-${hostConstants.alt-arch}-release/linux-${hostConstants.alt-arch}-flutter-gtk.zip";
        target = "bin/cache/artifacts/engine/linux-${hostConstants.alt-arch}-release";
      }
    ];

    # arm64?
    windows = [
      {
        path = "windows-x64/artifacts.zip";
        target = "bin/cache/artifacts/engine/windows-x64";
      }
      {
        path = "windows-x64-debug/windows-x64-flutter.zip";
        target = "bin/cache/artifacts/engine/windows-x64";
      }
      {
        path = "windows-x64/flutter-cpp-client-wrapper.zip";
        target = "bin/cache/artifacts/engine/windows-x64";
      }
      {
        path = "windows-x64-profile/windows-x64-flutter.zip";
        target = "bin/cache/artifacts/engine/windows-x64-profile";
      }
      {
        path = "windows-x64-release/windows-x64-flutter.zip";
        target = "bin/cache/artifacts/engine/windows-x64-release";
      }
    ];

    macos = [
      {
        path = "darwin-x64/framework.zip";
        target = "bin/cache/artifacts/engine/darwin-x64";
      }
      {
        path = "darwin-x64/gen_snapshot.zip";
        target = "bin/cache/artifacts/engine/darwin-x64";
      }
      {
        path = "darwin-x64-profile/artifacts.zip";
        target = "bin/cache/artifacts/engine/darwin-x64-profile";
      }
      {
        path = "darwin-x64-profile/framework.zip";
        target = "bin/cache/artifacts/engine/darwin-x64-profile";
      }
      {
        path = "darwin-x64-profile/gen_snapshot.zip";
        target = "bin/cache/artifacts/engine/darwin-x64-profile";
      }
      {
        path = "darwin-x64-release/artifacts.zip";
        target = "bin/cache/artifacts/engine/darwin-x64-release";
      }
      {
        path = "darwin-x64-release/framework.zip";
        target = "bin/cache/artifacts/engine/darwin-x64-release";
      }
      {
        path = "darwin-x64-release/gen_snapshot.zip";
        target = "bin/cache/artifacts/engine/darwin-x64-release";
      }
      {
        path = "darwin-${hostConstants.alt-arch}/artifacts.zip";
        target = "bin/cache/artifacts/engine/darwin-x64";
      }
    ];

    ios = [
      {
        path = "ios/artifacts.zip";
        target = "bin/cache/artifacts/engine/ios";
      }
      {
        path = "ios-profile/artifacts.zip";
        target = "bin/cache/artifacts/engine/ios-profile";
      }
      {
        path = "ios-release/artifacts.zip";
        target = "bin/cache/artifacts/engine/ios-release";
      }
      {
        path = "ios-usb-dependencies/libimobiledevice/0bf0f9e941c85d06ce4b5909d7a61b3a4f2a6a05/libimobiledevice.zip";
        target = "bin/cache/artifacts/libimobiledevice";
        hash = "sha256-EPzWDY5SYegep6DB9ESd/ApklzLtE8reEllMUPzmkLg=";
      }
      {
        path = "ios-usb-dependencies/libusbmuxd/19d6bec393c9f9b31ccb090059f59268da32e281/libusbmuxd.zip";
        target = "bin/cache/artifacts/libusbmuxd";
        hash = "sha256-RQT0Kq8rKKgokp1haASMZ8K84+M2ZbaJcs/MunZ7/L0=";
      }
      {
        path = "ios-usb-dependencies/libplist/cf5897a71ea412ea2aeb1e2f6b5ea74d4fabfd8c/libplist.zip";
        target = "bin/cache/artifacts/libplist";
        hash = "sha256-cx5758EQb/0SkrVusXGFzH2dUChzFd5dFpMKxlxKbS8=";
      }
      {
        path = "ios-usb-dependencies/openssl/22dbb176deef7d9a80f5c94f57a4b518ea935f50/openssl.zip";
        target = "bin/cache/artifacts/openssl";
        hash = "sha256-erz3j0oIZm2IqvFD41APkTgz7YZaaDReokMwGhFCsmA=";
      }
      {
        path = "ios-usb-dependencies/libimobiledeviceglue/050ff3bf8fdab6ce53a2ddc6ae49b11b1c02a168/libimobiledeviceglue.zip";
        target = "bin/cache/artifacts/libimobiledeviceglue";
        hash = "sha256-4rXsfBxIaByVcIuzs05G5RergFZrgaBs1XBmu7ibwAA=";
      }
      {
        path = "ios-usb-dependencies/ios-deploy/7a29ab0b6d611f2bf5de4b6f929a82a091866307/ios-deploy.zip";
        target = "bin/cache/artifacts/ios-deploy";
        hash = "sha256-1p6agbzur4xFai4ZzzjHp4ZvRv+VWcPygBgBYQdQ2Vw=";
      }
    ];

    android = [
      {
        path = "android-x86/artifacts.zip";
        target = "bin/cache/artifacts/engine/android-x86";
      }
      {
        path = "android-x64/artifacts.zip";
        target = "bin/cache/artifacts/engine/android-x64";
      }
      {
        path = "android-arm/artifacts.zip";
        target = "bin/cache/artifacts/engine/android-arm";
      }
      {
        path = "android-arm-profile/artifacts.zip";
        target = "bin/cache/artifacts/engine/android-arm-profile";
      }
      {
        path = "android-arm-release/artifacts.zip";
        target = "bin/cache/artifacts/engine/android-arm-release";
      }
      {
        path = "android-arm64/artifacts.zip";
        target = "bin/cache/artifacts/engine/android-arm64";
      }
      {
        path = "android-arm64-profile/artifacts.zip";
        target = "bin/cache/artifacts/engine/android-arm64-profile";
      }
      {
        path = "android-arm64-release/artifacts.zip";
        target = "bin/cache/artifacts/engine/android-arm64-release";
      }
      {
        path = "android-x64-profile/artifacts.zip";
        target = "bin/cache/artifacts/engine/android-x64-profile";
      }
      {
        path = "android-x64-release/artifacts.zip";
        target = "bin/cache/artifacts/engine/android-x64-release";
      }
      {
        path = "android-arm-profile/${hostPlatform.parsed.kernel.name}-x64.zip";
        target = "bin/cache/artifacts/engine/android-arm-profile/${hostPlatform.parsed.kernel.name}-x64";
      }
      {
        path = "android-arm-release/${hostPlatform.parsed.kernel.name}-x64.zip";
        target = "bin/cache/artifacts/engine/android-arm-release/${hostPlatform.parsed.kernel.name}-x64";
      }
      {
        path = "android-arm64-profile/${hostPlatform.parsed.kernel.name}-x64.zip";
        target = "bin/cache/artifacts/engine/android-arm64-profile/${hostPlatform.parsed.kernel.name}-x64";
      }
      {
        path = "android-arm64-release/${hostPlatform.parsed.kernel.name}-x64.zip";
        target = "bin/cache/artifacts/engine/android-arm64-release/${hostPlatform.parsed.kernel.name}-x64";
      }
      {
        path = "android-x64-profile/${hostPlatform.parsed.kernel.name}-x64.zip";
        target = "bin/cache/artifacts/engine/android-x64-profile/${hostPlatform.parsed.kernel.name}-x64";
      }
      {
        path = "android-x64-release/${hostPlatform.parsed.kernel.name}-x64.zip";
        target = "bin/cache/artifacts/engine/android-x64-release/${hostPlatform.parsed.kernel.name}-x64";
      }
    ];
  };
in
(lib.unique (
  lib.map (
    artifact:
    let
      artifactName = lib.removeSuffix ".${lib.last (lib.splitString "." artifact.path)}" artifact.path;
      artifactNameUnderscore = lib.replaceStrings [ "-" "/" ] [ "_M_" "_S_" ] artifactName;
      useEngineOutput = useNixpkgsEngine && (builtins.elem artifactNameUnderscore engines.outputs);
    in
    {
      path =
        if useEngineOutput then
          engines.${artifactNameUnderscore}
        else
          fetchurl {
            url = getUrl artifact.path;
            hash = artifactHashes.${artifact.path} or artifact.hash or "";
          };
      target = artifact.target;
      id = artifact.path;
    }
  ) (lib.concatMap (x: artifacts.${x}) supportedTargetFlutterPlatforms)
))
