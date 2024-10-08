let version = "3.5.3"; in
{ fetchurl }: {
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "1z6hl6pqsg2l7pfchzr5dk90b2dchidhwnnnc4q5dzz0xjikqrvx";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "12rzl1nm1y0q5ff9p8gslki4cz37y3bdn8p2s3x2nc81bdda4gn7";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "1rp54g8di8j715n955wdr6i0pcrx2dn73qmvmrisyahi0qjrk0py";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "001mpb3fniamlmnqmhxdpbvp8crdvnf6sam13vvfmnr6na1fpxil";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "0z9qjx2b2rmiqyqww0a5slj0pi1k8sn4fjihkn53im65rhhqra2y";
  };
}
