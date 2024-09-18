let version = "3.5.2"; in
{ fetchurl }: {
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "0k1h7kbcagm7s0n8696lzws814rabz3491khd7z78mb3ivahxw35";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "036jw4qq3wicyfpamy7v6qsbrj0m7dyny45yzdgil4snvfagvfsv";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "1wm1157hbsms872pp1fkn0i3khz3h4r909bdvpk2rhag2l928f0a";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "160dk1dpdzdh0pphmvdw7agavpyxniw8zf5w30yamkdi7r9g0l0b";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "0nrgjdzc2skqc2b52pzw78056jqrqmiwzwwd9wh699dwwfnrjcf4";
  };
}
