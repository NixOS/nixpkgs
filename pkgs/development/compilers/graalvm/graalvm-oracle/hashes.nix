# To update, get the latest URLs from Archive Downloads, eg.
# https://www.oracle.com/java/technologies/javase/graalvm-jdk23-archive-downloads.html
# Then run this script:
# $ rg -No "(https://.+)\"" -r '$1' pkgs/development/compilers/graalvm/graalvm-oracle/hashes.nix | \
#   parallel -k 'echo {}; nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri $(curl -s {}.sha256)'
{
  "23" = {
    "aarch64-linux" = {
      hash = "sha256-VlB664/l7NWFQrPE3vEJvCXkEzKEJ0ck/HNU5pGGTwU=";
      url = "https://download.oracle.com/graalvm/23/archive/graalvm-jdk-23.0.2_linux-aarch64_bin.tar.gz";
    };
    "x86_64-linux" = {
      hash = "sha256-2wmx/hi4PzOK+bMpFEN3SzFw2euhdTjOLuOcXm1gHfw=";
      url = "https://download.oracle.com/graalvm/23/archive/graalvm-jdk-23.0.2_linux-x64_bin.tar.gz";
    };
    "x86_64-darwin" = {
      hash = "sha256-tFmfv9OUMEqE6UNb98ZzBp1P4MVl0tRNcPD29YBM6jU=";
      url = "https://download.oracle.com/graalvm/23/archive/graalvm-jdk-23.0.2_macos-x64_bin.tar.gz";
    };
    "aarch64-darwin" = {
      hash = "sha256-DmRLktA9Ob30hC43i4sicT+qpO2ujv/w2pkp0eBN0Ms=";
      url = "https://download.oracle.com/graalvm/23/archive/graalvm-jdk-23.0.2_macos-aarch64_bin.tar.gz";
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
