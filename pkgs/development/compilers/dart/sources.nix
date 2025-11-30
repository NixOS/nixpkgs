let
  version = "3.10.2";
in
{ fetchurl }:
{
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    hash = "sha256-acOiEKtE+6lw0eXxYJX3yNX0EZCcsmNm35j6GdZPwe4=";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    hash = "sha256-jnwmWmca07ETjoAMDNZ2aDkKdFwCS4M57eN5nopg51c=";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    hash = "sha256-nEpdTeWN0NrB+NsMfGQpFvfcrp0qfjMyzT1ehp0QAQ0=";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    hash = "sha256-TRWC+DYvFjCPCd8syf2gX3/a9HXmObeIH6oBYowS/VU=";
  };
}
