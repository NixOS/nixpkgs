# To update, get the latest URLs from Archive Downloads, eg.
# https://www.oracle.com/java/technologies/javase/graalvm-jdk23-archive-downloads.html
# Then run this script:
# $ rg -No "(https://.+)\"" -r '$1' pkgs/development/compilers/graalvm/graalvm-oracle/hashes.nix | \
#   parallel -k 'echo {}; nix hash convert --hash-algo sha256 --to sri $(curl -s {}.sha256)'
{
  "22" = {
    "aarch64-linux" = {
      hash = "sha256-skemwlgUzJzqm2XOyKkjblIwKnHDSqpzdunrMB+Dlvs=";
      url = "https://download.oracle.com/graalvm/22/archive/graalvm-jdk-22.0.2_linux-aarch64_bin.tar.gz";
    };
    "x86_64-linux" = {
      hash = "sha256-GIGqLEMbBQbssXBDmDKwU7dXNo1xCb1CIpjKI+eTnNA=";
      url = "https://download.oracle.com/graalvm/22/archive/graalvm-jdk-22.0.2_linux-x64_bin.tar.gz";
    };
    "x86_64-darwin" = {
      hash = "sha256-n8vz/5bzjzHi9ZC7Yq3xngZVNcguJ7X9dC3vAFvvNSg=";
      url = "https://download.oracle.com/graalvm/22/archive/graalvm-jdk-22.0.2_macos-x64_bin.tar.gz";
    };
    "aarch64-darwin" = {
      hash = "sha256-O4IYBkBDJXRrCj3jISgSPVje85W2kd8cQmedlzfVh+c=";
      url = "https://download.oracle.com/graalvm/22/archive/graalvm-jdk-22.0.2_macos-aarch64_bin.tar.gz";
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
