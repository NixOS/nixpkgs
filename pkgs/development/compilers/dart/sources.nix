let
  version = "3.9.2";
in
{ fetchurl }:
{
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    hash = "sha256-TGel6P9oew5ao8DAMS5kCxLl1eknjZG7Jc7A32YofXk=";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    hash = "sha256-AdBnLbgmZvcvlFLfOO4VFqcs2bwpgYvT6t34LkBVYVI=";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    hash = "sha256-1i918/G/tEoi+9XPCltHx1hRbOyl3Me87IiJbiWD57o=";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    hash = "sha256-7CLoEnFYLe+B0+EOKlVa5dPYHGlRRlo9Fs/EeTjp+So=";
  };
}
