let
  version = "3.7.2";
in
{ fetchurl }:
{
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "1bj9libb4bnmgm4544876xz512i1nvp73fbxrs4jz0xfp398c206";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "0z35ndh7mdaz1dnd2yvv5g50jbfy563yclgfjlx9k400b7cn6vhh";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "1a2cwr3qyy8paxjhgb1xwcv4rm1ml0dfv1byl5zynmz0c6nwqlil";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "133q4jz5wszs0bja7pnfgjd7mvawdspgz866ip3m0v351zbzs5n2";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "0y3slablp94lbcm9bafg0p407axrdqxf33vpxc420ifqczpidmh2";
  };
}
