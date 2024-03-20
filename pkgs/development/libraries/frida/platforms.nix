{ lib }:
# Frida uses slightly nonstandard platform naming which we have to translate

let
  fridaHost = platform:
    if platform.isDarwin then platform.darwinPlatform
    else if platform.isLinux then (if platform.isAndroid then "android" else "linux")
    else if platform.isFreeBSD then "freebsd"
    else builtins.throw "unknown frida platform ${platform.config}";

  fridaProcessor = name: if name == "aarch64" then "arm64" else name;
  suffix = platform: if platform.isMusl then "-musl" else "";

  # Here is a list from release 16.1.11:
  knownFridaHosts = [
    "android-arm"
    "android-arm64"
    "android-x86"
    "android-x86_64"
    "freebsd-arm64"
    "freebsd-x86_64"
    "ios-arm64-simulator"
    "ios-arm64"
    "ios-arm64e"
    "ios-arm64eoabi"
    "ios-x86_64-simulator"
    "linux-arm64-musl"
    "linux-arm64"
    "linux-armhf"
    "linux-mips"
    "linux-mips64"
    "linux-mips64el"
    "linux-mipsel"
    "linux-x86"
    "linux-x86_64-musl"
    "linux-x86_64"
    "macos-arm64"
    "macos-arm64e"
    "macos-x86_64"
    "qnx-armeabi"
    "tvos-arm64-simulator"
    "tvos-arm64"
    "watchos-arm64-simulator"
    "watchos-arm64"
    "windows-x86"
    "windows-x86_64"
  ];

  platformToFridaHost = platform: "${fridaHost platform}-${fridaProcessor platform.parsed.cpu.name}${suffix platform}";

in
{
  inherit knownFridaHosts platformToFridaHost;
}
