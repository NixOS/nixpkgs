let
  version = "3.10.0";
in
{ fetchurl }:
{
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    hash = "sha256-VhavQcg1b51znMG8k8Gm3Uo4MPsIedVQixST3iTpoxc=";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    hash = "sha256-0J/JM1BcNvcqkiVKV5YCihxer964uev6xiAAoXh5igo=";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    hash = "sha256-aIYDKDuanngz2lPrWzoH14/qnFH92SW7/ZInddS6XqM=";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    hash = "sha256-onaBvoc8OJFpIoXbjWVudJTKgMdOhmE7gIX8bP+j4x0=";
  };
}
