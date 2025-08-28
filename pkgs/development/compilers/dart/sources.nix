let
  version = "3.8.2";
in
{ fetchurl }:
{
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    hash = "sha256-30f5sONEzlXcf8NrNPPK0vUYclULhIfj3H+Q9tlRuJE=";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    hash = "sha256-PO/YQEIKNSl302T9Lq+4pfOoUVrkJjFZ9bEETWujUpE=";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    hash = "sha256-YFfbTNkJ437F99zzSsCmW8NPtBMwtMNxjEPbGlDokG8=";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    hash = "sha256-KUW6qxHPdHIyjlVzcTmTuvkXlX+taRwUYcq9WglugxE=";
  };
}
