{ fetchFromGitHub
, ...
}:

rec {
  version = "0.10.5";
  rSrc = fetchFromGitHub {
    owner = "abathur";
    repo = "resholve";
    rev = "v${version}";
    hash = "sha256-SzJbA0wLeSwvXnAE4bTNqh0tnpFPkn6N1hp7sZGAkB4=";
  };
}
