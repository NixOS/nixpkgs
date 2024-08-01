{ fetchFromGitHub, asgiref }:

let
  version = "3.7.2";
in
asgiref.overrideAttrs (oldAttrs: {
  name = builtins.replaceStrings [ oldAttrs.version ] [ version ] oldAttrs.name;
  inherit version;

  src = fetchFromGitHub {
    owner = "django";
    repo = "asgiref";
    rev = "refs/tags/${version}";
    hash = "sha256-VW1PBh6+nLMD7qxmL83ymuxCPYKVY3qGKsB7ZiMqMu8=";
  };
})
