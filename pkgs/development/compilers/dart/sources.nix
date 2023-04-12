let version = "2.19.3"; in
{  fetchurl }: {
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "193hf56j7bws8bzqxxzz2sgbn2d80g5s8vp8ihi22cm3mmppfi4v";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "0b30l8kfcsl1j6w2vbq08p0v4h4gca013l5fpznjqq0midxhybnw";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "0qyi7ppsf4rmzx1qgx3qbn4k7bgbncxjql6a9f2b1aj6l6lllvmg";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "0iq7mdwpsnykk3j2bsgmazg30m4qg7i2lpv1ygbhy2lbhrkdpdck";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "0xksis14ff6bzjvycgxgldg96n88rh42adjyrrhcay2s183vh480";
  };
}
