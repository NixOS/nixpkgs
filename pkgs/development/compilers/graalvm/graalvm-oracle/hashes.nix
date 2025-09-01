# To update, get the latest URLs from Archive Downloads, eg.
# https://www.oracle.com/java/technologies/javase/graalvm-jdk23-archive-downloads.html
# Then run this script:
# $ rg -No "(https://.+)\"" -r '$1' pkgs/development/compilers/graalvm/graalvm-oracle/hashes.nix | \
#   parallel -k 'echo {}; nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri $(curl -s {}.sha256)'
{
  "25-ea-35" = {
    "aarch64-linux" = {
      hash = "sha256-DbESXsX/saJSizZ/s6ENsL3W9VASRRGYArKzjvqlRk8=";
      url = "https://github.com/graalvm/oracle-graalvm-ea-builds/releases/download/jdk-25.0.0-ea.35/graalvm-jdk-25.0.0-ea.35_linux-aarch64_bin.tar.gz";
    };
    "x86_64-linux" = {
      hash = "sha256-fR9cA8vwV7/w4eRAkrzft0cNW29tM2rCCjSoUEDcX1A=";
      url = "https://github.com/graalvm/oracle-graalvm-ea-builds/releases/download/jdk-25.0.0-ea.35/graalvm-jdk-25.0.0-ea.35_linux-x64_bin.tar.gz";
    };
    "x86_64-darwin" = {
      hash = "sha256-OZHBmZqwC5DpGmXSDah4f002XGBhreoumBXv0IEalRs=";
      url = "https://github.com/graalvm/oracle-graalvm-ea-builds/releases/download/jdk-25.0.0-ea.35/graalvm-jdk-25.0.0-ea.35_macos-x64_bin.tar.gz";
    };
    "aarch64-darwin" = {
      hash = "sha256-Q2HU2wHIPdanGTKFLNdllEEPXmERgqTyeVNMWKj/CvE=";
      url = "https://github.com/graalvm/oracle-graalvm-ea-builds/releases/download/jdk-25.0.0-ea.35/graalvm-jdk-25.0.0-ea.35_macos-aarch64_bin.tar.gz";
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
