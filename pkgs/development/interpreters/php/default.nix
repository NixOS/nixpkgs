{
  callPackage,
  stdenv,
  llvmPackages,
  pcre2,
}:

let
  commonArgs = {
    stdenv = if stdenv.cc.isClang then llvmPackages.stdenv else stdenv;
    pcre2 = pcre2.override {
      withJitSealloc = false; # See https://bugs.php.net/bug.php?id=78927 and https://bugs.php.net/bug.php?id=78630
    };
  };
in
{
  php82 = callPackage ./8.2.nix commonArgs;
  php83 = callPackage ./8.3.nix commonArgs;
  php84 = callPackage ./8.4.nix commonArgs;
  php85 = callPackage ./8.5.nix commonArgs;
}
