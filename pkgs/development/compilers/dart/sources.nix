let
  version = "3.9.3";
in
{ fetchurl }:
{
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    hash = "sha256-QnY9KG/zFj+5o/4wdR0lETHhRn3a6l340s/ybuNWxx0=";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    hash = "sha256-aMSMOV5kzd48z5aQgjjpQoJNWznz4slrXSdC8LRe8u8=";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    hash = "sha256-iEfEhHv3eu2VjAYrzPjVlXle1ISHZxJoC69MbIMXw1Y=";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    hash = "sha256-0ZMR3rNRBKQaQNt642xJaxUDdFpcrtWkFdMitMJz8ds=";
  };
}
