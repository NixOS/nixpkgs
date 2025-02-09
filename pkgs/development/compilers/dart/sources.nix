let version = "3.2.0"; in
{ fetchurl }: {
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "0a1mbi2si0ww9b96hx633xviwrbqk4skf7gxs0h95npw2cf6n9kd";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "0yhmhvfq8w6l8q5ahlxk5qbr3ji319snb8ghpi6y7px2pfbv5gwr";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "052vz5zjjwjbww81qws3vyj39wkw2i9mqqs8fcifzgzbfdyc8lb0";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "0wvpyjpvyaasazjmizb0ha3p70q3rhqpqq8bzl1bv9jrsgcniqsf";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "1z187sl652fzkp3nf044snjh09svnvmlxh0ribzf3b955a40l8cd";
  };
}
