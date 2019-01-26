{ cmake
, stdenv
, fetchurl
, bash
, unzip
, glibc
, openssl
, gcc
, libgit2
, libGLU_combined
, freetype
, xorg
, alsaLib
, cairo
, libuuid
, autoreconfHook
, gcc48
, fetchFromGitHub
, makeWrapper
} @args:

let
  pharo-vm-build = import ./build-vm.nix args;
  pharo-vm-build-legacy = import ./build-vm-legacy.nix args;
in

let suffix = if stdenv.is64bit then "64" else "32"; in

rec {
  # Build the latest VM
  spur = pharo-vm-build rec {
    name = "pharo-spur${suffix}";
    version = "git.${revision}";
    src = fetchFromGitHub {
      owner = "pharo-project";
      repo = "pharo-vm";
      rev = revision;
      sha256 = "0dkiy5fq1xn2n93cwf767xz24c01ic0wfw94jk9nvn7pmcfj7m62";
    };
    # This metadata will be compiled into the VM and introspectable
    # from Smalltalk. This has been manually extracted from 'git log'.
    #
    # The build would usually generate this automatically using
    # opensmalltalk-vm/.git_filters/RevDateURL.smudge but that script
    # is too impure to run from nix.
    revision = "6a63f68a3dd4deb7c17dd2c7ac6e4dd4b0b6d937";
    source-date = "Tue May 30 19:41:27 2017 -0700";
    source-url  = "https://github.com/pharo-project/pharo-vm";
  };

  # Build an old ("legacy") CogV3 VM for running pre-spur images.
  # (Could be nicer to build the latest VM in CogV3 mode but this is
  # not supported on the Pharo VM variant at the moment.)
  cog = pharo-vm-build-legacy rec {
    version = "2016.02.18";
    name = "pharo-cog${suffix}";
    base-url = http://files.pharo.org/vm/src/vm-unix-sources/blessed;
    src = fetchurl {
      url = "${base-url}/pharo-vm-${version}.tar.bz2";
      sha256 = "16n2zg7v2s1ml0vvpbhkw6khmgn637sr0d7n2b28qm5yc8pfhcj4";
    };
  };

}

