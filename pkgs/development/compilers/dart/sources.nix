let version = "3.4.2"; in
{ fetchurl }: {
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "1xg2pqmn268yi3b1hc6qky0fzhx38785x70v77px5x3fhzjvh5rs";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "1ybbxg6hkwdqva2xjl9srifrfryy6vacgv20lvmkhrqn59yl7m66";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "1pnh2jm29n0hvsj1gp4abm3dcq2mqagcf489ghbx6my1mhif232f";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "0hsrzgl3xn3lmps5cnp1yr8fvzzy19gj7pgdn22dabx52lx0x9j3";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "05ldjy3vhl8bhkyjmyq6yxwd503i0jk4vzkd2jk201yzwzwkjpvf";
  };
}
