let
  version = "3.8.1";
in
{ fetchurl }:
{
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    hash = "sha256-OTcd89ZPlPWz2cERnD9UkWTFYoxqE7lFG3tEhZ8fkRQ=";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    hash = "sha256-UIC8b0p4zM4OOOceRkdsCNYeCBRTZGlI8/DHcXepKPg=";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    hash = "sha256-eKMkAJe+47ebAJxp6tIuGq7e3ty+CT6qmACExWYQlsg=";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    hash = "sha256-DVjAEKNh8/FYixwvV5QvfMr3t6u+A0BP73oQLrY48J0=";
  };
}
