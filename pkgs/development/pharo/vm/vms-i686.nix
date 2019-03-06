{ alsaLib
, autoreconfHook
, bash
, cairo
, cmake
, fetchFromGitHub
, fetchurl
, file
, fontconfig
, freetype
, gcc5
, gdk_pixbuf
, gdb
, glib
, glibc
, gtk3-x11
, lib
, libGLU_combined
, libgit2
, libmoz2d
, libpng
, libpulseaudio
, libssh2
, libstdcxx5
, libuuid
, libxcb
, libXext
, libXv
, makeWrapper
, openssl
, pangox_compat
, pixman
, runCommand
, runtimeShell
, SDL2
, squeak
, stdenv
, unzip
, xlibs
, xorg
} @args:

let
  pharo-vm-build-legacy = import ./build-vm-legacy.nix args;
  pharo-vm-build = import ./build-vm.nix args;
  suffix = if stdenv.is64bit then "64" else "32";
in

rec {
  # Build the latest VM
  spur = pharo-vm-build rec {
    name = "pharo-spur${suffix}";
    version = "git.${revision}";
    src = fetchFromGitHub {
      owner = "studio";
      repo = "opensmalltalk-vm";
      rev = revision;
      sha256 = "0v97qmwvr6k5iqx2yax4i5f7g2z9q6b3f2ym483pykhc167969cl";
    };
    # This metadata will be compiled into the VM and introspectable
    # from Smalltalk. This has been manually extracted from 'git log'.
    #
    # The build would usually generate this automatically using
    # opensmalltalk-vm/.git_filters/RevDateURL.smudge but that script
    # is too impure to run from nix.
    revision = "2634b9afd1ed1272e98dffea9f81064942b2db66";
    source-date = "Tue Feb 22 19:41:27 2019 -0700.1";
    source-url  = "https://github.com/opensmalltalk/opensmalltalk-vm";
  };

  # Build an old ("legacy") CogV3 VM for running pre-spur images.
  # (Could be nicer to build the latest VM in CogV3 mode but this is
  # not supported on the Pharo VM variant at the moment.)
  cog = pharo-vm-build-legacy rec {
    version = "2016.02.18";
    name = "pharo-cog32";
    base-url = http://files.pharo.org/vm/src/vm-unix-sources/blessed;
    src = fetchurl {
      url = "${base-url}/pharo-vm-${version}.tar.bz2";
      sha256 = "16n2zg7v2s1ml0vvpbhkw6khmgn637sr0d7n2b28qm5yc8pfhcj4";
    };
  };
}
