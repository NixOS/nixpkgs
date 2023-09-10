let version = "3.0.6"; in
{ fetchurl }: {
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "0adasw9niwbsyk912330c83cqnppk56ph7yxalml23ing6x8wq32";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "0wj58cygjra1qq0ivsbjb710n03zi0jzx0iw5m2p8nr7w8ns551c";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "06wqq97d2v0bxp2pmc940dhbh8n8yf6p9r0sb1sldgv7f4r47qiy";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "1hg1g4pyr8cgy6ak4n9akidrmj6s5n86dqrx3ybi81c8z5lqw4r2";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "1hbh3gahnny2wfs31r64940z5scrgd8jf29mrzfadkpz54g0aizz";
  };
}
