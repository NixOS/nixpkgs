let
  version = "3.5.4";
in
{ fetchurl }:
{
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "0x4kjkgva143g0d07rcz9zd9dfmsr9zfhrx4kj9z0ap9s3rv6vdh";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "00iw0nsxhq4aas717b0vhcz3hlwrpyixbgkf9sksqk2x1w798if0";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "1v437zpksk0jhib6vhpcbvv715mv32zmwby8b3p9qd3k67fn87d9";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "0rv9rp8g5blhncqwciymhxh3z2832yp54lphxgsvkmm9y8s5w34d";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "02kv119swcp7y4n3yb2i5a4dagjpf0zq3b3an1apahj5zn6ak41g";
  };
}
