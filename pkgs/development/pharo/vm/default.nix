{ cmake, stdenv, fetchurl, bash, unzip, glibc, openssl, gcc, mesa, freetype, xorg, alsaLib, cairo, libuuid, autoreconfHook, gcc6, fetchFromGitHub } @args:

let
  pharo-vm-build = import ./build-vm.nix args;
  pharo-vm-build-legacy = import ./build-vm-legacy.nix args;
in

rec {
  # Build the latest VM for running p
  spur = pharo-vm-build rec {
    name = "pharo-vm";
    version = "git.${revision}";
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
    source-date = "Wed Apr 12 19:25:16 2017 +0200";
    source-url  = "https://github.com/pharo-project/pharo-vm";
  };

  # Build an old ("legacy") CogV3 VM for running pre-spur images.
  # (Could be nicer to build the latest VM in CogV3 mode but this is
  # not supported on the Pharo VM variant at the moment.)
  cog = pharo-vm-build-legacy rec {
    version = "2016.02.18";
    name = "pharo-vm-i386-${version}";
    base-url = http://files.pharo.org/vm/src/vm-unix-sources/blessed;
    src = fetchurl {
      url = "${base-url}/pharo-vm-${version}.tar.bz2";
      sha256 = "16n2zg7v2s1ml0vvpbhkw6khmgn637sr0d7n2b28qm5yc8pfhcj4";
    };
  };

}

