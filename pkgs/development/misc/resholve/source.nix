{
  fetchFromGitHub,
  ...
}:

rec {
  version = "0.10.6";
  rSrc = fetchFromGitHub {
    owner = "abathur";
    repo = "resholve";
    rev = "v${version}";
    hash = "sha256-iJEkfW60QO4nFp+ib2+DeDRsZviYFhWRQoBw1VAhzJY=";
  };
}
