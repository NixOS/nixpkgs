# To update, get the latest URLs from Archive Downloads, eg.
# https://www.oracle.com/java/technologies/javase/graalvm-jdk24-archive-downloads.html
# Then run this script:
# $ rg -No "(https://.+)\"" -r '$1' pkgs/development/compilers/graalvm/graalvm-oracle/hashes.nix | \
#   parallel -k 'echo {}; nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri $(curl -s {}.sha256)'
{
  "24" = {
    "aarch64-linux" = {
      hash = "sha256-YV3zrZOA7hzFiIb7y+ifDar0oZM4JWeuYKbDoCjcg0o=";
      url = "https://download.oracle.com/graalvm/24/archive/graalvm-jdk-24_linux-aarch64_bin.tar.gz";
    };
    "x86_64-linux" = {
      hash = "sha256-rldxp7TvhAQeDZAI91SEn6sUqldGgeATDrJ2BvPfsBI=";
      url = "https://download.oracle.com/graalvm/24/archive/graalvm-jdk-24_linux-x64_bin.tar.gz";
    };
    "x86_64-darwin" = {
      hash = "sha256-TIIOuVVPNzRN2WC+nv7vmHZc5B4flYpteJrjjiXrbRk=";
      url = "https://download.oracle.com/graalvm/24/archive/graalvm-jdk-24_macos-x64_bin.tar.gz";
    };
    "aarch64-darwin" = {
      hash = "sha256-rP4hiPk9RNwP6cDe5nZe2MXMeJzj8dZiXGjohqasg6s=";
      url = "https://download.oracle.com/graalvm/24/archive/graalvm-jdk-24_macos-aarch64_bin.tar.gz";
    };
  };
}
