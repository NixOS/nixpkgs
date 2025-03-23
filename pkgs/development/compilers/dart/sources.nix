let
  version = "3.7.1";
in
{ fetchurl }:
{
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "0bldcn4j99cv2a6g3s263929r7wqhjaxylwm26nd2jdfnqbmjxm2";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "191jig17mnk0gjys2xd0qr267idjv2h50qnaz0cciflj60b2az7m";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "1zj7k2bczb9yy63vjj8xm3ljd9sx9z77awf4wdvv6y02gnzxv4ga";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "0wgfl118j7s7xjz4i0m4gyzxzsjv7x9wq9xr2m036l4ngng9a4r8";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "1zj60jqpnv1apl4439vvxxrgfvg3azwaaizdmq8chfmrg97vr85x";
  };
}
