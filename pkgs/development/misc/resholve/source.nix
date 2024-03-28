{ fetchFromGitHub
, ...
}:

rec {
  version = "0.10.1";
  rSrc = fetchFromGitHub {
    owner = "abathur";
    repo = "resholve";
    rev = "v${version}";
    hash = "sha256-mXOC59I+04oaUlBK46YgaWbyudDwlqWHhAoCr1I6vhY=";
  };
}
