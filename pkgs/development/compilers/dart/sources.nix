let version = "3.0.0"; in
{ fetchurl }: {
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "0aav696x5p6zq6vfmv7zpy9v701dpbk0xwkyv2c2qdmrbb8wljb0";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "1l06qk4w03qrrmnflb7a9jcm8ssx0p7b95jkhyvdg878d79zrpb7";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "0p15njnry0kp9878lmg86p01bbvin8xm6131r8barzclcj5v3msd";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "0r96frjcqinhyzq809hv9yggm09clyc712ln3caqxfybcr552mm2";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "16qdcc6ssgh3158fpqld6sai3lxvyimvasjmgqrhfh7h8p0inzfw";
  };
}
