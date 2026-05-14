{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "compress.yazi";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "KKV9";
    repo = "compress.yazi";
    tag = "0.6";
    hash = "sha256-Mby185FCJY6nqHcHDQu+D5SLk+wGcyeUHK8yAvrd4TM=";
  };

  meta = {
    description = "Yazi plugin that compresses selected files to an archive";
    homepage = "https://github.com/KKV9/compress.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
  };
}
