let version = "3.1.4"; in
{ fetchurl }: {
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "0501siwhdynrqmxzfj9gc4a8mhr7kpf60p18a861p2plvaf4jvbf";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "1inz0cc553y6bd37lb3wklbb1vyflyyp9f8h6j2pdp14fsy4n1c0";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "1769n06fvn7f27dk497izs051f1gqaw0n1xkabbz31xxhiqalrby";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "1nrdq1f4shxmpx5w8rg8yv7qqhi59n87idfllbw9mdd1vcgcs3r8";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "0nw8f005pjmn3azqwd3n2zmiwnf1b678m7gcbas1ahdn0csz64lk";
  };
}
