let
  version = "3.10.7";
in
{ fetchurl }:
{
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    hash = "sha256-EES4leNoHZWFs/nQUJTzN+cCKGzxiANpLJrkXb1UKdA=";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    hash = "sha256-ovQkvU5BpqXHUlUebUKKranJUERhZPsAsfO3N+4jzKs=";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    hash = "sha256-gb3NiChgaYFxPFE+PUN37u3sQxxGvzXzJ3xquvLXvVE=";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    hash = "sha256-ik7qz012kOAzidYygkG8aaG2HLmA8j1Q9i66y1kg7HQ=";
  };
}
