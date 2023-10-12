let version = "3.1.3"; in
{ fetchurl }: {
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "00bjyjya5hb1aaywbbaqbsxas5q93xvxrz9sd3x40m3792zxdbfx";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "0nansfrnzb8ximg15my8yv5kc2gih60rkann7r008h7zk5cd8nkr";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "08njr5n7z94dfkmbi9wcdv5yciy94nzfgvjbdhsjswyq3h030a1b";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "0ff73ws20i2j5lk2h2dy6k3fbfx7l9na9gqyji37c0dc67vxyl01";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "1703vsmw0m867gqzd2wy93bab0gg7z40r9rfin4lzhxw20x2brs4";
  };
}
