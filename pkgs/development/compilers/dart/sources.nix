let version = "3.3.0"; in
{ fetchurl }: {
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "1cwxvn7321444mkpcv1vix5bi2ianiadvrjib6z5irdj8pbwlkih";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "1clang815wwy6szwl1rkjzl9d6zard15d1c2p6i7xpvvk3rb6m5j";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "00mjnzld4zbk37x7g7428by3dwpkc7nhja4p6dlhl1xj2lb4qs0r";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "1bdwdjjnfjrwcfg2iy76bh939kkgw25130if7fxl3jay0sj6pgry";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "0r9ypqd5b0l31bklm9q3g1aw9i1qyfkxr9vdn5wwfkicvqjiffs2";
  };
}
