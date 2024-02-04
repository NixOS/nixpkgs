{ fetchFromGitHub
, gradle_7
, jdk11
, lib
, stdenv
, rsync
, runCommand
, testers
}:

let
  corretto = import ./mk-corretto.nix {
    inherit lib stdenv rsync runCommand testers;
    jdk = jdk11;
    gradle = gradle_7;
    extraConfig = [
      # jdk11 is built with --disable-warnings-as-errors (see openjdk/11.nix)
      # because of several compile errors. We need to include this parameter for
      # Corretto, too.
      "--disable-warnings-as-errors"
    ];
    version = "11.0.20.9.1";
    src = fetchFromGitHub {
      owner = "corretto";
      repo = "corretto-11";
      rev = "b880bdc8397ec3dd6b7cd4b837ce846c9e902783";
      sha256 = "sha256-IomJHQn0ZgqsBZ5BrRqVrEOhTq7wjLiIKMQlz53JxsU=";
    };
  };
in
corretto
