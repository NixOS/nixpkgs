# To update, get the latest URLs from Archive Downloads, eg.
# https://www.oracle.com/java/technologies/javase/graalvm-jdk23-archive-downloads.html
# Then run this script:
# $ rg -No "(https://.+)\"" -r '$1' pkgs/development/compilers/graalvm/graalvm-oracle/hashes.nix | \
#   parallel -k 'echo {}; nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri $(curl -s {}.sha256)'
{
  "25-ea-34" = {
    "aarch64-linux" = {
      hash = "sha256-QS3AgGG0++k3B7ollL9X2AOcjeH468fJID+mTl+eVEo=";
      url = "https://github.com/graalvm/oracle-graalvm-ea-builds/releases/download/jdk-25.0.0-ea.34/graalvm-jdk-25.0.0-ea.34_linux-aarch64_bin.tar.gz";
    };
    "x86_64-linux" = {
      hash = "sha256-cBFyLiFaTX8MepRhfO/dvvqx8M6lto+JMdCdy8X6YBI=";
      url = "https://github.com/graalvm/oracle-graalvm-ea-builds/releases/download/jdk-25.0.0-ea.34/graalvm-jdk-25.0.0-ea.34_linux-x64_bin.tar.gz";
    };
    "x86_64-darwin" = {
      hash = "sha256-E4N8UnE74oGzpsUGYINuSZjjgZCYn43uwv4/eDtdZ+s=";
      url = "https://github.com/graalvm/oracle-graalvm-ea-builds/releases/download/jdk-25.0.0-ea.34/graalvm-jdk-25.0.0-ea.34_macos-x64_bin.tar.gz";
    };
    "aarch64-darwin" = {
      hash = "sha256-C0TnIFmhDLzI9QYqHJbZAQWvJNb1zX4PEOXp3JXV1hk=";
      url = "https://github.com/graalvm/oracle-graalvm-ea-builds/releases/download/jdk-25.0.0-ea.34/graalvm-jdk-25.0.0-ea.34_macos-aarch64_bin.tar.gz";
    };
  };
  "24" = {
    "aarch64-linux" = {
      hash = "sha256-dvJVfzLoz75ti3u/Mx8PCS674cw2omeOCYMFiSB2KYs=";
      url = "https://download.oracle.com/graalvm/24/archive/graalvm-jdk-24.0.2_linux-aarch64_bin.tar.gz";
    };
    "x86_64-linux" = {
      hash = "sha256-sBYaSbvB0PQGl1Mt36u4BSpaFeRjd15pRf4+SSAlm64=";
      url = "https://download.oracle.com/graalvm/24/archive/graalvm-jdk-24.0.2_linux-x64_bin.tar.gz";
    };
    "x86_64-darwin" = {
      hash = "sha256-3w+eXRASAcUL+muqPGV6gaKIPFtQl6n1q5PauG9+O6I=";
      url = "https://download.oracle.com/graalvm/24/archive/graalvm-jdk-24.0.2_macos-x64_bin.tar.gz";
    };
    "aarch64-darwin" = {
      hash = "sha256-LcdjTtk5xyXUGjU/c0Q/8y5w8vtXc2fxKmk2EH40lNw=";
      url = "https://download.oracle.com/graalvm/24/archive/graalvm-jdk-24.0.2_macos-aarch64_bin.tar.gz";
    };
  };
  "17" = {
    "aarch64-linux" = {
      hash = "sha256-vZkdSGuS3rdDN7iB4PE6dkycHpD8NYgZCA9zIfpRdeg=";
      url = "https://download.oracle.com/graalvm/17/archive/graalvm-jdk-17.0.12_linux-aarch64_bin.tar.gz";
    };
    "x86_64-linux" = {
      hash = "sha256-tvPaziTPGWDseQIW9MhvANT0PfZOTotUj2OC8EiUcT8=";
      url = "https://download.oracle.com/graalvm/17/archive/graalvm-jdk-17.0.12_linux-x64_bin.tar.gz";
    };
    "x86_64-darwin" = {
      hash = "sha256-PsrBRx8/qVpWxbdcZdueYKxFUfVu2gnrnaleYEnqd9c=";
      url = "https://download.oracle.com/graalvm/17/archive/graalvm-jdk-17.0.12_macos-x64_bin.tar.gz";
    };
    "aarch64-darwin" = {
      hash = "sha256-TN/cbJOV9nc+/NGRtmBfG3yOG3irkAq1z/NHIKP+/8U=";
      url = "https://download.oracle.com/graalvm/17/archive/graalvm-jdk-17.0.12_macos-aarch64_bin.tar.gz";
    };
  };
}
