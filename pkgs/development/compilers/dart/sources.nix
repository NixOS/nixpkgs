let version = "3.0.5"; in
{ fetchurl }: {
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "0c9a4fwwf5r4as4k1fa66ddmrjwlz5wr3j5fw1d26406hmw8m1qw";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "1636yggn4ynq7axw79m2n8i8v193kx38zxc6iybagcv9hld8jck4";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "0cq5q94fcj9v5y3bhq9dzwhpmvfw8flpq4rwlcif5js46icpjyv6";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "0v5nn9j5rbvgnmkkj866mpwnp03ndc8lbg8bx7ydycj9srra7yq5";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "03drn7s6w6xz1szk6x4gny0kv4hcbwqvcz8yxxmqkinpgsf1ap4a";
  };
}
