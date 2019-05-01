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
  pharo-vm-build = import ./build-vm-x86_64.nix args;
  suffix = "64";
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
    revision = "f3be54a2657f31de321338645feef6b641b1a121";
    source-date = "Tue May 30 19:41:27 2017 -0700.1";
    source-url  = "https://github.com/opensmalltalk/opensmalltalk-vm";
  };
}
