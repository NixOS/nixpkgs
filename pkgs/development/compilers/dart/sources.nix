let version = "3.3.2"; in
{ fetchurl }: {
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
    sha256 = "0ii494ffj5vkxnpq3aykxmn54cw4jlf45slwlg9g1crm6j3lcwak";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    sha256 = "0ffqwbmwx737hrq04rbpyxqfm86mqhfayq2i1ssjkjgqyzzrpmy7";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    sha256 = "079jq4sp8sw8y4khw8j8l2q38149bjmn8j5yibmnzyxpwyc4ysx2";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    sha256 = "07ixd7qj78y6m27cv9mjlkr2kdnmld6cxc23x4dip3a02drs8990";
  };
  "${version}-i686-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
    sha256 = "1jwjiyxcr2ii4f7rlb4hsjq9hlmdhv9f41wa5camhy74x56z5fhn";
  };
}
