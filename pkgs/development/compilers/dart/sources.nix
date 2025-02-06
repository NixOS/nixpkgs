let
  version = "3.6.0";
in
{ fetchurl }:
{
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "0avky36jmknnp3jwz4p0yz5yv8wqwl0v7rhv0s4v75r9v6mv2ndq";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "1802lx2ijpi4lkbbnvlkk1swn579rpbnmxmvghz6flxa99acdnqv";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "1gz7ai977ynl554rplfjnd585q5m429ax51js3806w4ch07z30hg";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "18smc4nj77dvsg99mk69d0h1y9cp3914zjdbimhp5v0ydr1zy54f";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "0k8ikz0rwhbgx6gdnxysikm8zcv3k6gf8d3a47wb5xx9dhgyk3vw";
  };
}
