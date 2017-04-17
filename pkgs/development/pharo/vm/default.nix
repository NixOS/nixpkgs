{ stdenv, fetchurl, bash, unzip, glibc, openssl, gcc, mesa, freetype, xorg, alsaLib, cairo, libuuid, makeDesktopItem, autoreconfHook, gcc6, fetchFromGitHub } @args:

let pharo-vm-build = import ./build-vm.nix args; in

{
  pharo-vm = pharo-vm-build rec {
    name = "pharo-vm";
    version = "git.${revision}";
    binary-basename = "pharo-vm";
    src = fetchFromGitHub {
      owner = "pharo-project";
      repo = "pharo-vm";
      rev = revision;
      sha256 = "114ydx015i8sg4xwy1hkb7vwkcxl93h5vqz4bry46x2gnvsay7yh";
    };
    # This metadata will be compiled into the VM and introspectable
    # from Smalltalk. This has been manually extracted from 'git log'.
    #
    # The build would usually generate this automatically using
    # opensmalltalk-vm/.git_filters/RevDateURL.smudge but that script
    # is too impure to run from nix.
    revision = "1c38b03fb043a2962f30f080db5b1292b5b7badb";
    sourceDate = "Wed Apr 12 19:25:16 2017 +0200";
    sourceURL  = "https://github.com/pharo-project/pharo-vm";
  };
}
