let
  version = "3.6.1";
in
{ fetchurl }:
{
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "1zysaln86rzxb56g10nzih7mzw2q7n7i93gzm5j2469imgly95xp";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "1x0z360dzwn5hwidnmkcjx8r87fmc7c38vkfl94c90z8kyw1rncg";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "0khm531mbvdlfqy00pkfcm4vckmfa02rb4p6ma8zzw9azrgcr4li";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "1d1mnkch3mlr31rwxjr1lmrmnp8vknd4ni5fyf9rq544jx0kgvgv";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "110m6wqx5cpvpx85fsq5frabxhlvqbjfpsjfd4nabsqa0bcdpnr3";
  };
}
