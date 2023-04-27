let version = "2.19.6"; in
{ fetchurl }: {
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "1nlmzappjk1f85iajlvqkvkqfd8ka7svsmglbh57ivvssvb6d6lr";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "1dpd8czllsxqly7hrcazp8g9b5zj6ibs93l5qyykijjbyjv58srw";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "170bzz4505fffz4lbaxif9ryaw8pl8ylgkbjsd0w32xpng0bf4v9";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "0kvhvwd2q8s7mnjgvhl6gr3y73agcd0y79sm844xd8ybd9gg5pqg";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "02iyzdz9grm3rc2dg7l1clww6n5n4kncv0gg6mlkgvmhk4hn9w1r";
  };
}
