{
  fetchFromGitHub,
<<<<<<< HEAD
  gradle_8,
=======
  gradle_7,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  jdk11,
  lib,
  stdenv,
  rsync,
  runCommand,
  testers,
}:

let
  corretto = import ./mk-corretto.nix rec {
    inherit
      lib
      stdenv
      rsync
      runCommand
      testers
      ;
    jdk = jdk11;
<<<<<<< HEAD
    gradle = gradle_8;
=======
    gradle = gradle_7;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    extraConfig = [
      # jdk11 is built with --disable-warnings-as-errors (see openjdk/11.nix)
      # because of several compile errors. We need to include this parameter for
      # Corretto, too.
      "--disable-warnings-as-errors"
    ];
<<<<<<< HEAD
    version = "11.0.29.7.1";
=======
    version = "11.0.26.4.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    src = fetchFromGitHub {
      owner = "corretto";
      repo = "corretto-11";
      rev = version;
<<<<<<< HEAD
      hash = "sha256-/VlV8tAo1deOZ5Trc4VlLNtpjWx352qUGZmfVbj7HuU=";
    };
  };
in
corretto.overrideAttrs (oldAttrs: {
  patches = (oldAttrs.patches or [ ]) ++ [
    ./corretto11-gradle8.patch
  ];

})
=======
      hash = "sha256-buJlSvmyOVeMwaP9oDcHhG+Sabr1exf0nRUt4O7MaIY=";
    };
  };
in
corretto
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
