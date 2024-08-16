let version = "3.4.4"; in
{ fetchurl }: {
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "1j7rh2kh8r67ywr4259zqwpkbj3g2isbf6piyh8j6fpgjsqbx9zx";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "05y3gfgcplnwsg1m3vgjhk0hg8sk7i92zch7zg08h3zywca04xfa";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "0ih3yx0bjigfbv5dfc262rw3y4ps5pzdilps4k1scb1xhs8y9kml";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "1nv7vvqcf6qsp4faqk2pqffr9kv6d5gic813k9zk20i8w6gcqs0r";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "00prc4fry3kh42lz9w34phdn07v1dm1qkkp52nph3jakg5y5dkm2";
  };
}
