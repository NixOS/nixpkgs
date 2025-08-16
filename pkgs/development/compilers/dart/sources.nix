let
  version = "3.9.1";
in
{ fetchurl }:
{
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    hash = "sha256-XApbc08k6KnQlBWUgQCiTqmmR1P2kBnFGb9XbO/l26Q=";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    hash = "sha256-simCXF/8mwXmwF8IM9LdJ1V/Xn7kKLEmzyll5PMdTQM=";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    hash = "sha256-2Oycfwro8kLqnHa5hGqu/9SExlaHm+/Y6O5/wejRZ9s=";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    hash = "sha256-nnPC2/VXuEQyitpPC0Kjj1hbgibnfj6WRWJn/GiuJ2k=";
  };
}
