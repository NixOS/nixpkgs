{ fetchFromGitHub
, ...
}:

rec {
  version = "0.10.2";
  rSrc = fetchFromGitHub {
    owner = "abathur";
    repo = "resholve";
    rev = "v${version}";
    hash = "sha256-QXIX3Ai9HUFosvhfYTUJILZ588cvxTzULUUp1LYkQ0A=";
  };
}
