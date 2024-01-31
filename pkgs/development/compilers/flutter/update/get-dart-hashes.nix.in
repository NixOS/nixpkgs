let
  dartVersion = "@dart_version@";
  platform = "@platform@";
in
{
  x86_64-linux = { fetchzip }:
    fetchzip {
      url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${dartVersion}/sdk/dartsdk-linux-x64-release.zip";
      sha256 = "";
    };
  aarch64-linux = { fetchzip }:
    fetchzip {
      url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${dartVersion}/sdk/dartsdk-linux-arm64-release.zip";
      sha256 = "";
    };
  x86_64-darwin = { fetchzip }:
    fetchzip {
      url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${dartVersion}/sdk/dartsdk-macos-x64-release.zip";
      sha256 = "";
    };
  aarch64-darwin = { fetchzip }:
    fetchzip {
      url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${dartVersion}/sdk/dartsdk-macos-arm64-release.zip";
      sha256 = "";
    };
}.${platform}
