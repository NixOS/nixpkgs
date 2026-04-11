{
  fetchFromGitHub,
  ...
}:

rec {
  version = "0.10.7";
  rSrc = fetchFromGitHub {
    owner = "abathur";
    repo = "resholve";
    rev = "v${version}";
    hash = "sha256-aUhxaxniGcmFAawUTXa5QrWUSpw5NUoJO5y4INk5mQU=";
  };
}
