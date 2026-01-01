{
<<<<<<< HEAD
  fetchFromGitHub,
  gradle_8,
=======
  corretto21,
  fetchFromGitHub,
  gradle_7,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  jdk21,
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
    jdk = jdk21;
<<<<<<< HEAD
    gradle = gradle_8;
    version = "21.0.9.11.1";
=======
    gradle = gradle_7;
    version = "21.0.6.7.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    src = fetchFromGitHub {
      owner = "corretto";
      repo = "corretto-21";
      rev = version;
<<<<<<< HEAD
      hash = "sha256-d62rXVgVlOM3M18c8GioFtMi/GhmCEMLQwy/EWAJW7I=";
    };
  };
in
corretto.overrideAttrs (oldAttrs: {
  patches = (oldAttrs.patches or [ ]) ++ [
    ./corretto21-gradle8.patch
  ];

})
=======
      hash = "sha256-kF7Quf8bU5scfunmwfEYLkje/jEJOx7CFnBIUWCovzI=";
    };
  };
in
corretto
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
