let
  version = "3.10.4";
in
{ fetchurl }:
{
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    hash = "sha256-KfbHwoxjWsg5UZMGw6wTcerJ++1P9Iub9Yw8980dduY=";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    hash = "sha256-cktk96/jhHyGJMO2PKcJ6T9Jj1hmCQMffaSNjx+kkUc=";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    hash = "sha256-go+qYU/C38wNC0TsZG+V1pQzEkzgyBpUbnXd2KX5pPo=";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    hash = "sha256-YKmjTrEWXTMdd23In7T9Q7nYva8soTfB/c+Y1siavuw=";
  };
}
