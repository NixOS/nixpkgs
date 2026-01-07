{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "compress.yazi";
  version = "0-unstable-2026-01-05";

  src = fetchFromGitHub {
    owner = "KKV9";
    repo = "compress.yazi";
    rev = "c9c16d8eb3d8f15bea5d58419229529921c58c94";
    hash = "sha256-tllxA9rlyQGuFHMMhoTjjAAJImsCTAgawBd3c9ZGzMU=";
  };

  meta = {
    description = "Yazi plugin that compresses selected files to an archive";
    homepage = "https://github.com/KKV9/compress.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
  };
}
