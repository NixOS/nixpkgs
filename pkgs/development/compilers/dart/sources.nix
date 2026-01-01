let
<<<<<<< HEAD
  version = "3.10.4";
=======
  version = "3.9.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
{ fetchurl }:
{
  versionUsed = version;
  "${version}-x86_64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-x64-release.zip";
<<<<<<< HEAD
    hash = "sha256-KfbHwoxjWsg5UZMGw6wTcerJ++1P9Iub9Yw8980dduY=";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    hash = "sha256-cktk96/jhHyGJMO2PKcJ6T9Jj1hmCQMffaSNjx+kkUc=";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    hash = "sha256-go+qYU/C38wNC0TsZG+V1pQzEkzgyBpUbnXd2KX5pPo=";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    hash = "sha256-YKmjTrEWXTMdd23In7T9Q7nYva8soTfB/c+Y1siavuw=";
=======
    hash = "sha256-8nkG1hUPn0B3r5xxBnGMjgOa66Ax3LQgVqMx+3Tj3S8=";
  };
  "${version}-aarch64-darwin" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
    hash = "sha256-2gqn816Usv8l69QrfJsh1DCu5ljibaBfZQn4ThUBlIA=";
  };
  "${version}-aarch64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-arm64-release.zip";
    hash = "sha256-IXkJWLbGXLV6Gjw/tQj0Tdz7d7gioJADnuR+WD/N4Og=";
  };
  "${version}-x86_64-linux" = fetchurl {
    url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
    hash = "sha256-YbS5SI4bQlW5S+F61Iri3bI8b75ngkz4ED0LKPqKuBY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
