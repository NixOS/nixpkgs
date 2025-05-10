let
  version = "3.7.3";
in
{ fetchurl }:
{
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "02g8pdirn9bsmqmmrnwxv2x9ynxpsk5i3k03jicc04wz4xzkxa4q";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "1334zb9nkvv9m5kplhynkl518ys1c2j844zwsx8v7181i38pjr7b";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "1bbqzz4kab7nyspl6i0pah17x9h9yjbpa7kzxqz8ijkzs966ym0n";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "1cl236ihrigp277x0yh628f3k1qf7c99iyfgxns0ikrggn0a4wmp";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "1da185r7d0s83h4v7waqg3yb5k9pqbmlcvgr1wfjhzd17m686cc2";
  };
}
