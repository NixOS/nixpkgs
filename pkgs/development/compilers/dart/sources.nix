let version = "3.2.4"; in
{ fetchurl }: {
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "107sq5m684mxw5k21zfs3iyihzbqkfmh0vpj17qca19rghnxgn02";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "08jbcdm5li30xdy85whdah186g0yiasgl12h6vi1vgld15ifjsab";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "0f40riqcdnjwjnv6si5186h6akrnhnwqrfrgfvm4y0gpblw88c2s";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "1bkrfg3xzkc4zrbl5ialg5jwpb7l0xmrd9aj7x5kwz2v8n8w013n";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "0jddia0s7byl7p6qbljp444qs11r8ff58s5fbchcrsmkry3pg8gi";
  };
}
