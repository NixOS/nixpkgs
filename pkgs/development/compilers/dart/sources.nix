let version = "3.3.3"; in
{ fetchurl }: {
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "0amlh1cx0jshd3fdrs18dp3ws3qwmi3qhjpg991330mlvwn93zik";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "0rxjd2znvzl5hznc055yda4pqbf86dim2gn6dbq72s4p0412sjyq";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "15d5gc7r2d43ylkcjcg44srcyg3c6g1s0d95pxzyff5jx287dnpk";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "1gggfxyn3sndgmplw1gn4k1xhcyhrsyw19k112ba0cm663vrcymc";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "1p82m0sr7mch0nabw2d73dys8lnpgf79b65dswaf8prnba8rn1lj";
  };
}
