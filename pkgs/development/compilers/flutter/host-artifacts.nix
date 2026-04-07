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
  stamps,
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
        path = lib.removePrefix "flutter_infra_release/" stamps."material_fonts.stamp";
        target = "bin/cache/artifacts/material_fonts";
        hash = "sha256-5W+o6btFif3pZL495FHz5bJR5KHq+x3JjZSt0DTdWoY=";
      }
      {
        path = lib.removePrefix "flutter_infra_release/" stamps."gradle_wrapper.stamp";
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
        path = "ios-usb-dependencies/libimobiledevice/${
          stamps."libimobiledevice.stamp"
        }/libimobiledevice.zip";
        target = "bin/cache/artifacts/libimobiledevice";
        hash = "sha256-EPzWDY5SYegep6DB9ESd/ApklzLtE8reEllMUPzmkLg=";
      }
      {
        path = "ios-usb-dependencies/libusbmuxd/${stamps."libusbmuxd.stamp"}/libusbmuxd.zip";
        target = "bin/cache/artifacts/libusbmuxd";
        hash = "sha256-RQT0Kq8rKKgokp1haASMZ8K84+M2ZbaJcs/MunZ7/L0=";
      }
      {
        path = "ios-usb-dependencies/libplist/${stamps."libplist.stamp"}/libplist.zip";
        target = "bin/cache/artifacts/libplist";
        hash = "sha256-cx5758EQb/0SkrVusXGFzH2dUChzFd5dFpMKxlxKbS8=";
      }
      {
        path = "ios-usb-dependencies/openssl/${stamps."openssl.stamp"}/openssl.zip";
        target = "bin/cache/artifacts/openssl";
        hash = "sha256-erz3j0oIZm2IqvFD41APkTgz7YZaaDReokMwGhFCsmA=";
      }
      {
        path = "ios-usb-dependencies/libimobiledeviceglue/${
          stamps."libimobiledeviceglue.stamp"
        }/libimobiledeviceglue.zip";
        target = "bin/cache/artifacts/libimobiledeviceglue";
        hash = "sha256-4rXsfBxIaByVcIuzs05G5RergFZrgaBs1XBmu7ibwAA=";
      }
      {
        path = "ios-usb-dependencies/ios-deploy/${stamps."ios-deploy.stamp"}/ios-deploy.zip";
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
