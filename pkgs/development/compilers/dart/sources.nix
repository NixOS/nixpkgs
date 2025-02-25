let
  version = "3.7.0";
in
{ fetchurl }:
{
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "1xfphfyawnw9v9f8rmbp02bpnqyrm83jv6d1xdnxqlh58bdcj0fn";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "1fv4d4xjpl3sqq33ax4qkcp0y9m3wm3lzkyz69c0pwy5xds7rzcv";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "0vv2kmphx1vddgp9q6kv8z5f2bsb5dghsjbidp9318861ny9m13w";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "03dqg2wwnn01jyh869lhccik6g1ksxf5wxwpqmynk8b42dpmlyrn";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "0bnm0qdy1hfz09nv9cz8ngnngr0irhkcxgkmgmdq408gfa1q16fn";
  };
}
