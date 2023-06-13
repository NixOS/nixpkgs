let version = "3.0.4"; in
{ fetchurl }: {
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "07p2fjk4jhnzhwqlmfjrlx9i11cj389fyk6kj6ri4ygpcfy3933k";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "1p1b4vqcrgw6bvxpr5f1mvbkxq3nqbdj6maq4svhkd8rwrwp7g8h";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "1hagjgh991kqghm7ffwx3wlq1ija20h1dmd2g8py1pvw167fwkfh";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "19gw8nkh77m009jwj92wcqjdp7xxp5p7aw4psf2ghbbl5mrmimzy";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "1phbaqq9lfq60bbf2pr38vngszrrd4931qzkd8772226ha79fsr0";
  };
}
