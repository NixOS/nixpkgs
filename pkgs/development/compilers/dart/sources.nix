let
  version = "3.9.0";
in
{ fetchurl }:
{
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    hash = "sha256-rRzjX/9ZtO2h/51+idHl0xzauGGS872vk7qjb1rk2L8=";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    hash = "sha256-+7QB2n4v0BKn7LgLnARPnHOybM9rylkRgjn5yWia4t4=";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    hash = "sha256-6aAosL5TJeLL9RGKtsbEB9MC+yIK5dx9nW9WSGdvtyQ=";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    hash = "sha256-db8rrcVs1q/4KQQqARLKXzz1C89/2VwpvHZlBXncAOE=";
  };
}
