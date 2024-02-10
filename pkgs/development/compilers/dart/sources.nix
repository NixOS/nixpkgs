let version = "3.2.6"; in
{ fetchurl }: {
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "05w5v6f302gwwpa3my8baz4spmdmqrimmc659wgki1h64ch1yrlp";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "1dmd70jjpfi19rmlvj2hbggw92z03jm8irrwx6r0bk7r748cj11f";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "1hs1mvk90qb0nijm8wcvv6xkd79z44i2bpcv2nh933lysdys664q";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "0j0xmyxdmzn4ii24j27yw6l3074ay4n2qjyzh967cpbg9yhr0cr5";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "0ml9dvnd7f0rld3wfnnmv7arfs821zg8rqaq1c7zvqhkj3i0dwci";
  };
}
