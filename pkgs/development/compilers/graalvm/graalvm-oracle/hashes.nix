# To update, get the latest URLs from Archive Downloads, eg.
# https://www.oracle.com/java/technologies/javase/graalvm-jdk23-archive-downloads.html
# Then run this script:
# $ rg -No "(https://.+)\"" -r '$1' pkgs/development/compilers/graalvm/graalvm-oracle/hashes.nix | \
#   parallel -k 'echo {}; nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri $(curl -s {}.sha256)'
{
  "25" = {
    "aarch64-linux" = {
      hash = "sha256-7dd1ZcdlcKbfXzjlPVRSQQLywbHPdO69n1Hn/Bn2Z80=";
      url = "https://download.oracle.com/graalvm/25/archive/graalvm-jdk-25.0.1_linux-aarch64_bin.tar.gz";
    };
    "x86_64-linux" = {
      hash = "sha256-1KsCuhAp5jnwM3T9+RwkLh0NSQeYgOGvGTLqe3xDGDc=";
      url = "https://download.oracle.com/graalvm/25/archive/graalvm-jdk-25.0.1_linux-x64_bin.tar.gz";
    };
    "x86_64-darwin" = {
      hash = "sha256-p2LKHZoWPjJ5C5KG869MFjaXKf8nmZ2NurYNe+Fs/y8=";
      url = "https://download.oracle.com/graalvm/25/archive/graalvm-jdk-25.0.1_macos-x64_bin.tar.gz";
    };
    "aarch64-darwin" = {
      hash = "sha256-Gd/UmtES5ubCve3FB8aFm/ISlPpMFk8b5nDUacZbeZM=";
      url = "https://download.oracle.com/graalvm/25/archive/graalvm-jdk-25.0.1_macos-aarch64_bin.tar.gz";
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
