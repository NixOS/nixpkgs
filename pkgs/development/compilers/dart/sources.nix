let
  version = "3.9.4";
in
{ fetchurl }:
{
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    hash = "sha256-8nkG1hUPn0B3r5xxBnGMjgOa66Ax3LQgVqMx+3Tj3S8=";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    hash = "sha256-2gqn816Usv8l69QrfJsh1DCu5ljibaBfZQn4ThUBlIA=";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    hash = "sha256-IXkJWLbGXLV6Gjw/tQj0Tdz7d7gioJADnuR+WD/N4Og=";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    hash = "sha256-YbS5SI4bQlW5S+F61Iri3bI8b75ngkz4ED0LKPqKuBY=";
  };
}
