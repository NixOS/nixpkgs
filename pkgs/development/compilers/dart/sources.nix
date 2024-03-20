let version = "3.3.1"; in
{ fetchurl }: {
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "1jihiryf8lm4mc5wrnhjwlyazpmhk3n40f8z7r25xnz7glafwvg5";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "1d6404r9vhp8q5r4nf3hlcgyvxlyxv63jzd4zlmdxghvm68kkv01";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "08amw2mw2zfpd7savydxsv8ncy8yk76ak1aixgb1csyh8pn4pagc";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "0mnplv2vzzfvg7a7xj8vrc75lvsj9xksbwzd3cc7s0xjxvyic40v";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "1ndj3nlw6qd94w3h4kw7jyihm71jlp3y0kc0ybgwh2r22dd2r2yd";
  };
}
