let
  version = "3.3.4";
in
{ fetchurl }:
{
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "0jicbpdhwlag51wgjbaxicj3mpvjnxx35g10ji1v8vxzas8msa32";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "0l8bsrhk7ycb7q2b3w4j76qkab4py2m535qa466xj6nwlyi99i81";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "1jdx0sk3356rn3ik9pfx19fc8ppjivcsnk1c44s72wg83ml3yiy3";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "1cm710bifr2g04h520a8r8jz75ndy4apr1y4kljknvyfc0m94wv7";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "0j5j582lvlwdaqznb8bi96x3sck13l82l0p627bqpn6nm5qv21sj";
  };
}
