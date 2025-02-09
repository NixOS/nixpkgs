let
  version = "3.6.2";
in
{ fetchurl }:
{
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "1n5y34y8j4wiy9vxab01knhf8as8jd7a1dybvrkxf905brplpiwa";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "15b22r1406jyf5s7hl56lc8rv2cvh0n8w9j4ns8f0a1zsyivyfs5";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "1r8kxdv84p3q5r131h9w3aq3kzgsz0qnq9m4nhjrjbcj8h4xnxgl";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "13a0ccq4jcxxgcb7jxg3lyjqc2vdw8nlh2qc7pbrq4y8fvn56aas";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "0hvw8w0xgjp3y3vfwhfn7h80kw1la0x2ihs3bv5y52sdp8rwvczf";
  };
}
