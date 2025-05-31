let
  version = "3.8.0";
in
{ fetchurl }:
{
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "0qkhzk9mn7xhdg03g3nj24zfalm4fd8k054gnncdsjn2vz1fhgpg";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "1vlyncm8hyfvwkdjvvkmra3b3mj7rz7sxwy2xjh07dkrmvw0n4cy";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "09gmkyg0h662n8wd3k1mx8sglvwa9l5cfhaq934hvcvpc16ajssy";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "1kpkd1c48y0v6hi5pabxhijd04aqbq1fqw3lcsrfkyig84gawbhj";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "0bcb95wadwhq0m64h9mrycdzp9ssnkh4lh3x3hf19py0ak6ix14v";
  };
}
