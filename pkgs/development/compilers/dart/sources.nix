let
  version = "3.10.9";
in
{ fetchurl }:
{
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    hash = "sha256-pd37vWDOIKGdek/CuUSH7sVyiKqlLOW6GLT4IkzkwYA=";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    hash = "sha256-99gMhvkzSJmYEsGuD3kBN1e3l685Xyy6cNICegC+Vk4=";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    hash = "sha256-Z8mPnmppTtPLNiY0Ny1pRzBAs3EoNtQsr82zxWwKBOs=";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    hash = "sha256-1DudOiG4LvKjfTGUW5nmuI9fjcROwZG0c/1inXjQuZQ=";
  };
}
